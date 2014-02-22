class Note < ActiveRecord::Base
  validates :title, presence: true

  belongs_to :user 
  has_and_belongs_to_many :subjects
  has_many :documents
  
  acts_as_taggable_on :tags
  
  acts_as_readable on: :created_at
  
  def self.search(search)
    if search
      #where('title LIKE ?', "%#{search}%")
      q = "%#{search}%"
        Note.select('distinct notes.*').joins("LEFT JOIN taggings on Notes.id = taggings.taggable_id")
        .joins("LEFT JOIN tags on tags.id = taggings.tag_id")
        .where('title LIKE ? OR tags.name LIKE ?', q, q )
    else
      all
    end
  end
  
end
