module SubjectsHelper
  def prepare_view_content
    @user = current_user
    @uni_years = @user.current_university.uni_years
    if @subject 
      @semesters = @subject.uni_year ? @subject.uni_year.semesters : []    
    else
      @semesters = []
    end
    @teachers = @user.current_university.teachers
    @years = (Subject::MAX_YEAR_BEGIN..Subject::MAX_YEAR_END).to_a
    @number_of_outlines_list = (1..Subject::MAX_OUTLINE).to_a
    @times = 1.upto(Period::MAX_TIME).to_a
    @days = 1.upto(Period::MAX_DAY).to_a
    @courses = @user.current_university.courses
    
    #For schedule rendering
    @periods = Hash.new
    if @subject
      @subject.periods.each do |p|
        @periods[ [p.day, p.time] ] = true
      end
    end 
  end
end
