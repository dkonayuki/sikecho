class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :university_id, presence: true
  validates :password_confirmation, presence: true
  
  has_secure_password
  
  belongs_to :university
  belongs_to :faculty
  belongs_to :course 
  
  has_and_belongs_to_many :subjects
  has_many :notes, dependent: :destroy
  
  acts_as_reader
  
  def name_kanji
    "#{first_name_kanji} #{last_name_kanji}"  
  end
  
end
