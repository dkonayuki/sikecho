class UniYear < ActiveRecord::Base
  
  #maximum semester number in one year
  MAX_NO = 3
  
  belongs_to :university
  validates :university, presence: true
  validates :name, presence: true
  validates :no, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: UniYear::MAX_NO }

  has_many :semesters
  has_many :subjects, through: :semesters
  
end
