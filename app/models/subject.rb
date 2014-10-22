class Subject < ActiveRecord::Base
  #for subject_path
  include Rails.application.routes.url_helpers
  #for custom activity
  include PublicActivity::Common

  validates :name, presence: true
  validates :semester_id, presence: true
  validates :uni_year_id, presence: true
  validates :course, presence: true
  
  has_attached_file :picture, styles: {thumbnail: "120x120#", small: "150x150^"}, 
                              #local config
                              url: "/uploads/subjects/:id/picture/:style/:basename.:extension",
                              path: ":rails_root/public/:url" #dont really need path
                              
  validates_attachment_content_type :picture, content_type: ["image/jpg", "image/gif", "image/png", "image/jpeg"]

  has_many :notes_subjects
  has_many :notes, through: :notes_subjects
  has_many :outlines, dependent: :destroy
  has_many :periods, dependent: :destroy

  has_and_belongs_to_many :teachers
  has_and_belongs_to_many :educations

  belongs_to :course
  belongs_to :semester
  belongs_to :uni_year
  
  accepts_nested_attributes_for :periods, allow_destroy: true
  
  acts_as_taggable_on :tags
  
  #versioning
  has_paper_trail only: [:description], on: [:update]
  
  #count tracking
  is_impressionable counter_cache: true, column_name: :view_count, unique: :all
  
  DEFAULT_OUTLINE = 12
  MAX_OUTLINE = 30
  MAX_YEAR_BEGIN = 2010
  MAX_YEAR_END = 2020
  
  def self.search(search)
    if search
      q = "%#{search.downcase}%"
      where('subjects.name LIKE ?', q)
      #select('distinct subjects.*').joins(:teachers)
      #.where('subjects.name LIKE ? OR teachers.last_name_kanji LIKE ? OR teachers.first_name_kanji LIKE ?', q, q, q)
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

end