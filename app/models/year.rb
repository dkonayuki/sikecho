class Year < ActiveRecord::Base
  has_many :semesters
  
  belongs_to :university
end
