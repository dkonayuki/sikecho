class Course < ActiveRecord::Base
  
  #dont need to validate faculty_id because of nested resource
  validates :faculty, presence: true
  validates :name, presence: true, length: 1..16

  belongs_to :faculty
  
  has_many :subjects
  has_many :educations
  
end
