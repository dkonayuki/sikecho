class Education < ActiveRecord::Base
  #scope for ordering
  scope :ordered, -> { joins('LEFT OUTER JOIN uni_years ON uni_years.id = educations.uni_year_id')
    .joins('LEFT OUTER JOIN semesters ON semesters.id = educations.semester_id')
    .order('educations.year ASC, uni_years.no ASC, semesters.no ASC, created_at ASC') }

  belongs_to :user
  belongs_to :university
  belongs_to :faculty
  belongs_to :course
  belongs_to :uni_year
  belongs_to :semester
  
  has_many :subjects, through: :registers
  has_many :registers
  
  #def subjects
    #awesome hack for getting distinct subjects from education, 
    #has_many: subjects, through: :periods will duplicate subjects
    #select subjects which has period has education id is exactly equal to this education object
    #Subject.select('distinct subjects.*').joins(periods: :educations).where('educations.id = ?', self.id)
  #end
  
end
