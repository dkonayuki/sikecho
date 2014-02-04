module ScheduleHelper
  def get_schedule_content
    #For schedule rendering
    @periods = Hash.new
    @user.subjects.each do | subject |
      key = [subject.day, subject.time]
      #value = period.subject
      @periods[key] = subject
    end
  end
end
