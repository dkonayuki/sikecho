class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password_confirmation, presence: true, on: :create
  
  has_secure_password
    
  has_many :notes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :educations, dependent: :destroy

  accepts_nested_attributes_for :educations, allow_destroy: true
  
  acts_as_reader
  
  has_settings do |s|
    s.key :note, defaults: { order: :time }
    s.key :subject, defaults: { style: :all }
    s.key :education
  end
  
  def name_kanji
    "#{first_name_kanji} #{last_name_kanji}"  
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
