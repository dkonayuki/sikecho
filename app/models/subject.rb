class Subject < ActiveRecord::Base
  validates :name, presence: true
  validates :semester_id, presence: true
  validates :uni_year_id, presence: true
  
  has_attached_file :picture, styles: {small: "150x150>"}, 
                              #local config
                              url: "/uploads/subjects/:id/picture/:style/:basename.:extension",
                              path: ":rails_root/public/:url" #dont really need path
                              
  validates_attachment_content_type :picture, content_type: ["image/jpg", "image/gif", "image/png", "image/jpeg"]

  has_many :notes_subjects
  has_many :notes, through: :notes_subjects
  has_and_belongs_to_many :teachers
  
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
      q = "%#{search.downcase}%"
      where('subjects.name LIKE ?', q)
      #select('distinct subjects.*').joins(:teachers)
      #.where('subjects.name LIKE ? OR teachers.last_name_kanji LIKE ? OR teachers.first_name_kanji LIKE ?', q, q, q)
    else
      all
    end
  end
  
  def display_picture_small
    if self.picture.present? && self.picture.url(:small).present?
      self.picture.url(:small)
    else
      'lecture.png'
    end
  end
  
  def self.MAX_YEAR_BEGIN
    2012
  end
  
  def self.MAX_YEAR_END
    2016
  end

end