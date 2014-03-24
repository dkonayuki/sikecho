class University < ActiveRecord::Base
  has_many :faculties
  has_many :teachers
  has_many :uni_years
  has_many :users
  
  def subjects
    courses = Course.where('faculty_id IN (?)', faculty_ids)
    Subject.where('course_id IN (?)', courses.ids)
  end
end
