class Education < ActiveRecord::Base
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
