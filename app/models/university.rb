class University < ActiveRecord::Base
  has_many :faculties
  has_many :teachers
  has_many :uni_years
  has_many :users
  
  def courses
    Course.where('faculty_id IN (?)', faculty_ids)
  end
  
  def subjects
    Subject.where('course_id IN (?)', self.courses.ids)
  end
end
