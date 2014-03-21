class Faculty < ActiveRecord::Base
  belongs_to :university
  
  has_many :teachers
  has_many :courses
  has_many :users
end