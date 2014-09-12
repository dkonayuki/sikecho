module EducationsHelper
  def prepare_view_content
    @universities = University.all
    @years = (Subject::MAX_YEAR_BEGIN..Subject::MAX_YEAR_END).to_a
    @times = 1.upto(Period::MAX_TIME).to_a
    @days = 1.upto(Period::MAX_DAY).to_a
    
    #@education is always created at 'new' action
    if @education.university
      @faculties = @education.university.faculties
      if @education.faculty
        @courses = @education.faculty.courses
      else
        @courses = []
      end

      @uni_years = @education.university.uni_years
      if @education.uni_year
        @semesters = @education.uni_year.semesters
      else
        @semesters = []
      end
    else
      #faculty list from first university in the select option
      @faculties = @universities.first.faculties
      @courses = []
      
      #uni_year list from first university in the select option
      @uni_years = @universities.first.uni_years
      @semesters = []
    end
  end
end
