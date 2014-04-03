class Faculty < ActiveRecord::Base
  belongs_to :university
  
  has_many :teachers
  has_many :courses, dependent: :destroy
  has_many :educations
end