class Subject < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates_presence_of :semester

  has_and_belongs_to_many :faculties
  has_and_belongs_to_many :notes
  has_and_belongs_to_many :teachers
  has_and_belongs_to_many :users
  
  has_many :outlines
  
  belongs_to :semester
  
  acts_as_taggable_on :tags
    
  def self.search(search)
    if search
      where('name LIKE ?', "%#{search}%")
    else
      all
    end
  end

end