class University < ActiveRecord::Base
  has_many :faculties, dependent: :destroy
  has_many :teachers
  has_many :uni_years
  has_many :educations
  
  has_attached_file :picture, styles: {thumbnail: "60x60#", small: "150x150>"}, 
                              #local config
                              url: "/uploads/universities/:id/picture/:style/:basename.:extension",
                              path: ":rails_root/public/:url" #dont really need path
                              
  validates_attachment_content_type :picture, content_type: ["image/jpg", "image/gif", "image/png", "image/jpeg"]
  
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
  
end
