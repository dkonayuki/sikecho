class Course < ActiveRecord::Base
  belongs_to :faculty
  
  has_many :users
  
  has_and_belongs_to_many :subjects
end
