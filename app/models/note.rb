class Note < ActiveRecord::Base
  #for custom activity
  include PublicActivity::Common
  
  validates :title, presence: true
  validates :subjects, presence: true

  belongs_to :user 
  has_many :notes_subjects
  has_many :subjects, through: :notes_subjects
  has_many :documents, dependent: :destroy
  
  has_many :votes, as: :votable, dependent: :destroy
  has_many :favorites, as: :favoritable, dependent: :destroy
  
  #for tags
  acts_as_taggable_on :tags
  
  #unread - read checking
  acts_as_readable on: :created_at
  
  #count tracking, add counter_cache collumn
  is_impressionable counter_cache: true, column_name: :view_count, unique: :all
  
  #after_create do |note|
    #note.subjects.each do |subject|
      #broadcast('/subjects/#{subject.id}', )
    #end
  #end
  
  # class method, run on collection proxy, relation
  # collection proxy example: subject.notes
  # relation example: Subject.all
  def self.search(search)
    if search
      #where('title LIKE ?', "%#{search}%")
      #search by title, tag, subject name
      q = "%#{search.downcase}%"
      select('distinct notes.*').joins('LEFT JOIN taggings ON notes.id = taggings.taggable_id').joins(:subjects)
      .joins('LEFT JOIN tags ON tags.id = taggings.tag_id')
      .where('lower(title) LIKE ? OR lower(tags.name) LIKE ? OR lower(subjects.name) LIKE ?', q, q, q)
    else
      all
    end
  end
  
  #check favorite
  def is_favorited?(user)
    user.favorited?(self)
  end
  
  #get like number
  def like_number
    self.votes.where('value = ?', 1).count
  end
  
  #get dislike number
  def dislike_number
    self.votes.where('value = ?', -1).count
  end
  
  #get rating
  def rating
    like_number - dislike_number
  end
  
  def comments_count
    self.documents.map{|d| d.comments.count}.sum
  end
    
  # get users who registered subjects that has this note
  def registered_users
    User.select('distinct users.*')
      .joins('INNER JOIN educations ON educations.current_user_id = users.id')
      .joins('INNER JOIN registers ON registers.education_id = educations.id')
      .joins('INNER JOIN subjects ON subjects.id = registers.subject_id')
      .joins('INNER JOIN notes_subjects ON notes_subjects.subject_id = subjects.id')
      .joins('INNER JOIN notes ON notes.id = notes_subjects.note_id')
      .where('notes.id = ?', self.id)
  end
  
end
