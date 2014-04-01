class Subject < ActiveRecord::Base
  validates :name, presence: true
  validates :semester_id, presence: true
  validates :uni_year_id, presence: true

  has_many :notes_subjects
  has_many :notes, through: :notes_subjects
  has_and_belongs_to_many :teachers
  has_and_belongs_to_many :users
  
  has_many :outlines, dependent: :destroy
  has_many :periods, dependent: :destroy
  
  belongs_to :course
  belongs_to :semester
  belongs_to :uni_year
  
  accepts_nested_attributes_for :periods, allow_destroy: true
  
  acts_as_taggable_on :tags
  
  has_paper_trail only: [:description], on: [:update]
  
  is_impressionable counter_cache: true, column_name: :view_count, unique: :all
    
  def self.search(search)
    if search
      where('subjects.name LIKE ?', "%#{search}%")
    else
      all
    end
  end
  
  def self.MAX_YEAR_BEGIN
    2012
  end
  
  def self.MAX_YEAR_END
    2016
  end

end