class Semester < ActiveRecord::Base
  belongs_to :uni_year
  
  has_many :subjects
end
