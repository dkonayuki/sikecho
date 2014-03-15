class Subject < ActiveRecord::Base
  validates :name, presence: true
  validates :semester_id, presence: true
  validates :uni_year_id, presence: true
  validate :validate_same_year

  has_and_belongs_to_many :faculties
  has_and_belongs_to_many :notes
  has_and_belongs_to_many :teachers
  has_and_belongs_to_many :users
  
  has_many :outlines, dependent: :destroy
  has_many :periods, dependent: :destroy
  
  belongs_to :semester
  belongs_to :uni_year
  
  accepts_nested_attributes_for :periods, allow_destroy: true
  
  acts_as_taggable_on :tags
  has_paper_trail only: [:description], on: [:update]
    
  def self.search(search)
    if search
      where('name LIKE ?', "%#{search}%")
    else
      all
    end
  end
  
  def validate_same_year
    same_year = Subject.where(name: self.name, year: self.year)
    if !same_year.empty? && same_year.first != self
      errors.add(:year, 'This year for subject existed')
    end
  end
  
  def self.MAX_YEAR_BEGIN
    2012
  end
  
  def self.MAX_YEAR_END
    2016
  end

end