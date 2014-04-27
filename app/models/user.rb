class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, authentication_keys: [:login]
         
  validates :username, presence: true, length: 4..10, on: :create, uniqueness: { case_sensitive: false }
  
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

  acts_as_reader
  
  has_settings do |s|
    s.key :note, defaults: { order: :time }
    s.key :subject, defaults: { style: :all }
    s.key :education
  end
  
  has_attached_file :avatar, styles: {thumbnail: ["60x60#", :jpg], small: ["150x150>", :jpg]}, #force type
                              #local config
                              url: "/uploads/users/:id/avatar/:style/:basename.:extension",
                              path: ":rails_root/public/:url" #dont really need path
                              
  validates_attachment_content_type :avatar, content_type: ["image/jpg", "image/gif", "image/png", "image/jpeg"]
  
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
    if self.avatar.exists?
      self.avatar.url(:small)
    else
      'user.png'
    end
  end
  
  def display_comment_image
    if self.avatar.exists?
      self.avatar.url(:small)
    else
      'avatar.png'
    end
  end
  
  def current_university
    Education.find(self.settings(:education).current).university
  end
  
  def current_faculty
    Education.find(self.settings(:education).current).faculty    
  end
  
  def current_course
    Education.find(self.settings(:education).current).course
  end
  
  def current_subjects
    Education.find(self.settings(:education).current).subjects
  end
  
end
