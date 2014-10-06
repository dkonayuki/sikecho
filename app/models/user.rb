class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter], authentication_keys: [:login]
         
  validates :username, presence: true, length: 4..16, on: :create, uniqueness: { case_sensitive: false }
  
  #validates :email, presence: true, uniqueness: true, format: /@/
  #validates :password_confirmation, presence: true, on: :create
  #validates :password, presence: true, on: :create, length: 6..20
  #devise will validate email, password, password_confirmation
  
  #use devise instead
  #has_secure_password
  
  #use both username and email for login
  attr_accessor :login
    
  has_many :notes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :educations, dependent: :destroy
  
  has_one :current_education, class_name: 'Education', foreign_key: "current_user_id"

  acts_as_reader
  
  has_settings do |s|
    s.key :note, defaults: { order: :time }
    s.key :subject, defaults: { order: :all }
  end
  
  has_attached_file :avatar, styles: {thumbnail: ["60x60#", :jpg], small: ["150x150>", :jpg]}, #force type
                              #local config
                              url: "/uploads/users/:id/avatar/:style/:basename.:extension",
                              path: ":rails_root/public/:url" #dont really need path
                              
  validates_attachment_content_type :avatar, content_type: ["image/jpg", "image/gif", "image/png", "image/jpeg"]
  validates_attachment_size :avatar, in: 0..2.megabytes

  #override for login with username - email
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { value: login.downcase }]).first
    else
      where(conditions).first
    end
  end
    
  def name_kanji
    "#{first_name_kanji} #{last_name_kanji}"  
  end
  
  def display_name
    if self.nickname? 
      self.nickname
    else
      self.username
    end
  end
  
  def display_profile_image
    if self.avatar.present? && self.avatar.url(:small).present?
      self.avatar.url(:small)
    else
      ActionController::Base.helpers.asset_path('user.png')
    end
  end
  
  def display_comment_avatar
    if self.avatar.present? && self.avatar.url(:small).present?
      self.avatar.url(:small)
    else
      ActionController::Base.helpers.asset_path('avatar.png')
    end
  end
  
  def current_university
    self.current_education.university
  end
  
  def current_faculty
    self.current_education.faculty    
  end
  
  def current_course
    self.current_education.course
  end
  
  def current_subjects
    self.current_education.subjects
  end
  
  # sign in
  # find existed user, if not, create a new user
  def self.find_for_provider_oauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end
  
  # add info from facebook session for new user b4 sign up
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.provider_data"]
        user.email = data.info["email"] if user.email.blank?
        user.username = data.info["name"] if user.username.blank?
        user.uid = data["uid"]
        user.provider = data["provider"]
        if data.info["image"]
          #get avatar from fb
          avatar_url = process_uri(data.info["image"])
          #new open() for Spoof File Checks issue
          user.avatar = open(avatar_url)
        end
      end
    end
  end
  
  def self.process_uri(uri)
    avatar_url = URI.parse(uri)
    avatar_url.scheme = 'https'
    avatar_url.to_s
  end
  
  protected
  def confirmation_required?
    false
  end
  
end
