class University < ActiveRecord::Base
  has_many :faculties, dependent: :destroy
  has_many :teachers
  has_many :uni_years
  has_many :educations
  
  translates :name
  
  has_attached_file :logo, styles: {thumbnail: "60x60#", small: "150x150>"}, 
                              #local config
                              url: "/uploads/universities/:id/logo/:style/:basename.:extension",
                              path: ":rails_root/public/:url" #dont really need path
                              
  validates_attachment_content_type :logo, content_type: ["image/jpg", "image/gif", "image/png", "image/jpeg"]
  
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
  
end
