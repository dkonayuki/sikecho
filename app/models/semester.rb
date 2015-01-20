class Semester < ActiveRecord::Base
  
  #maximum year number in university
  MAX_NO = 8
    
  validates :uni_year, presence: true
  validates :name, presence: true
  validates :no, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: Semester::MAX_NO }

  belongs_to :uni_year
  
  has_many :subjects
  has_many :education
end
