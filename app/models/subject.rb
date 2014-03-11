class Subject < ActiveRecord::Base
  validates :name, presence: true
  validates :semester_id, presence: true
  validates :uni_year_id, presence: true

  has_and_belongs_to_many :faculties
  has_and_belongs_to_many :notes
  has_and_belongs_to_many :teachers
  has_and_belongs_to_many :users
  
  has_many :outlines
  
  belongs_to :semester
  belongs_to :uni_year
  
  acts_as_taggable_on :tags
  has_paper_trail
    
  def self.search(search)
    if search
      where('name LIKE ?', "%#{search}%")
    else
      all
    end
  end

end