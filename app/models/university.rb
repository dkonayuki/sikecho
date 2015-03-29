class University < ActiveRecord::Base
  
  # constant hash for university model specifically
  AREAS =
    {
      1 => [:hokkaido], #hokkaido
      2 => [:akita, :aomori, :fukushima, :iwate, :miyagi, :yamagata], #tohoku
      3 => [:chiba, :gunma, :ibaraki, :kanagawa, :saitama, :tochigi, :tokyo], #kanto
      4 => [:fukui, :ishikawa, :nagano, :niigata, :toyama, :yamanashi], #tokai
      5 => [:aichi, :gifu, :shizuoka, :mie], #koshinetsu
      6 => [:hyogo, :kyoto, :nara, :osaka, :shiga, :wakayama], #kansai
      7 => [:hiroshima, :okayama, :shimane, :tottori, :yamaguchi], #chugoku
      8 => [:ehime, :kagawa, :kochi, :tokushima], #shikoku
      9 => [:fukuoka, :kagoshima, :kumamoto, :miyazaki, :nagasaki, :oita, :saga] #kyushu
    }
    
  CITIES = AREAS.values.flatten
    
  has_many :faculties, dependent: :destroy
  has_many :teachers
  has_many :uni_years
  has_many :educations
  
  #university's name will change accordingly with locale
  #need to edit manually in other locale otherwise default name will be used
  #translates :name
  
  has_attached_file :logo, styles: {thumbnail: "60x60#", small: "150x150>"},
                              convert_options: {
                                all: '-background white -flatten +matte'
                              },
                              #local config
                              url: "/uploads/universities/:id/logo/:style/:basename.:extension",
                              path: ":rails_root/public/:url" #dont really need path
                              
  validates_attachment_content_type :logo, content_type: ["image/jpg", "image/gif", "image/png", "image/jpeg"]
  
  has_attached_file :picture, styles: {},
                              #local config
                              url: "/uploads/universities/:id/picture/:style/:basename.:extension",
                              path: ":rails_root/public/:url" #dont really need path
                              
  validates_attachment_content_type :picture, content_type: ["image/jpg", "image/gif", "image/png", "image/jpeg"]

  validates :name, presence: true, length: 2..16, uniqueness: { case_sensitive: false }
  validates :codename, presence: true, length: 3..10, uniqueness: { case_sensitive: false }
  validates :city, presence: true, length: 1..16
  
  def self.search(search)
    if search
      q = "%#{search.downcase}%"
      where('lower(universities.name) LIKE ? OR lower(universities.en_name) LIKE ?', q, q)
    else
      all
    end
  end
  
  def display_name
    I18n.locale == :en ? en_name : name
  end
  
  def courses
    Course.where('faculty_id IN (?)', faculty_ids)
  end
  
  def subjects
    Subject.where('course_id IN (?)', self.courses.ids)
  end
  
  def notes
    Note.select('distinct notes.*').joins(:subjects).where('subjects.id IN (?)', self.subjects.ids)
    #Note.select('distinct notes.*').joins(:subjects).where(subjects: {id: self.subjects.ids})
  end
  
  def users
    #.joins('INNER JOIN educations ON educations.id = educations_periods.education_id')
    User.select('distinct users.*').joins(:educations).where('educations.current_user_id = users.id AND educations.university_id = ?', self.id)
  end
  
  def display_logo_thumbnail
    if self.logo.present? && self.logo.url(:thumbnail).present?
      self.logo.url(:thumbnail)
    else
      'university.png'
    end
  end
  
  def display_logo_original
    if self.logo.present? && self.logo.url(:original).present?
      self.logo.url(:original)
    else
      'university.png'
    end
  end
  
  def display_picture
    if self.picture.present? && self.picture.url(:original).present?
      self.picture.url(:original)
    else
      'university_bg.jpg'
    end
  end
  
  #for rails_admin, city field will use a select box instead of normal text
  def city_enum
    # Do not select any value, or add any blank field. RailsAdmin will do it for you.
    AREAS.values.flatten
  end
  
end
