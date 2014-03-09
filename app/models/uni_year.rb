class UniYear < ActiveRecord::Base
  has_many :semesters
  has_many :subjects, through: :semesters
  
  belongs_to :university
end
