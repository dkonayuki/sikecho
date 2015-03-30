class Subject < ActiveRecord::Base
  
  #default scope
  #for example: note.subjects.first will use the order below
  scope :ordered, -> {order('year DESC, name ASC, view_count DESC')}

  #for subject_path
  include Rails.application.routes.url_helpers
  #for custom activity
  include PublicActivity::Common

  validates :name, presence: true
  
  #in order to pass params and create new subject
  #validates course_id instead of course
  validates :semester_id, presence: true
  validates :uni_year_id, presence: true
  validates :course_id, presence: true
  
  has_attached_file :picture, styles: {thumbnail: "120x120#", small: "150x150^"}, 
                              #local config
                              url: "/uploads/subjects/:id/picture/:style/:basename.:extension",
                              path: ":rails_root/public/:url" #dont really need path
                              
  validates_attachment_content_type :picture, content_type: ["image/jpg", "image/gif", "image/png", "image/jpeg"]

  #notes_subjects is used instead of has_and_belongs_to_many
  #so we can use :notes_count in sql
  has_many :notes_subjects
  has_many :notes, through: :notes_subjects
  
  has_many :outlines, dependent: :destroy
  has_many :periods, dependent: :destroy

  has_and_belongs_to_many :teachers
  has_many :educations, through: :registers
  has_many :registers

  belongs_to :course
  belongs_to :semester
  belongs_to :uni_year
  
  #for tag
  acts_as_taggable_on :tags
  
  #versioning
  has_paper_trail only: [:description], on: [:update]
  
  #count tracking, use column view_count to reorder
  is_impressionable counter_cache: true, column_name: :view_count, unique: :all
  
  DEFAULT_OUTLINE = 12
  MAX_OUTLINE = 30
  MAX_YEAR_BEGIN = 2010
  MAX_YEAR_END = 2020
  
  # class method, run on collection proxy, relation
  # collection proxy example: subject.notes
  # relation example: Subject.all
  def self.search(search)
    if search
      q = "%#{search.downcase}%"
      #search with teachers' name too
      #tags should not be searched in here
      joins(:teachers)
      .where('lower(subjects.name) LIKE ? OR lower(teachers.last_name_kanji) LIKE ? OR lower(teachers.first_name_kanji) LIKE ?' +
        'OR lower(teachers.first_name) LIKE ? OR lower(teachers.last_name) LIKE ?', q, q, q, q, q)
    else
      all
    end
  end
  
  def display_picture_thumbnail
    if picture.present? && picture.url(:thumbnail).present?
      picture.url(:thumbnail)
    else
      ActionController::Base.helpers.asset_path('lecture.png')
    end
  end
  
  def display_picture_small
    if picture.present? && picture.url(:small).present?
      picture.url(:small)
    else
      ActionController::Base.helpers.asset_path('lecture.png')
    end
  end
  
  # typeahead is for auto complete search bar
  # used in json
  def typeahead_thumbnail
    if picture.present? && picture.url(:thumbnail).present?
      picture.url(:thumbnail)
    else
      ActionController::Base.helpers.asset_path('lecture.png')
    end
  end
  
  def typeahead_subject_path
    subject_path(self, locale: I18n.locale)
  end
  
  def is_registered?(user)
    user.registered?(self)
  end
  
  # get users who registered this subject
  def registered_users
    User.select('distinct users.*')
      .joins('INNER JOIN educations ON educations.current_user_id = users.id')
      .joins('INNER JOIN registers ON registers.education_id = educations.id')
      .joins('INNER JOIN subjects ON subjects.id = registers.subject_id')
      .where('subjects.id = ?', self.id)
  end

end