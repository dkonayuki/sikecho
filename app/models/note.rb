class Note < ActiveRecord::Base
  validates :title, presence: true
  validates :subjects, presence: true

  belongs_to :user 
  has_many :notes_subjects
  has_many :subjects, through: :notes_subjects
  has_many :documents, dependent: :destroy
  
  acts_as_taggable_on :tags
  
  acts_as_readable on: :created_at
  
  is_impressionable counter_cache: true, column_name: :view_count, unique: :all
  
  #after_create do |note|
    #note.subjects.each do |subject|
      #broadcast('/subjects/#{subject.id}', )
    #end
  #end
  
  def self.search(search)
    if search
      #where('title LIKE ?', "%#{search}%")
      q = "%#{search.downcase}%"
      select('distinct notes.*').joins("LEFT JOIN taggings on Notes.id = taggings.taggable_id")
      .joins("LEFT JOIN tags on tags.id = taggings.tag_id")
      .where('title LIKE ? OR tags.name LIKE ?', q, q)
      #no more search by subject name
    else
      all
    end
  end
  
end
