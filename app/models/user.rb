class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :university_id, presence: true
  validates :password_confirmation, presence: true, on: :create
  
  has_secure_password
  
  belongs_to :university
  belongs_to :faculty
  belongs_to :course 
  
  has_and_belongs_to_many :subjects
  has_many :notes, dependent: :destroy
  
  acts_as_reader
  
  has_settings do |s|
    s.key :note, defaults: { order: :time }
    s.key :subject, defaults: { style: :all }
  end
  
  def name_kanji
    "#{first_name_kanji} #{last_name_kanji}"  
  end
  
end
