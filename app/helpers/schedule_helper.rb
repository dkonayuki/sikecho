module ScheduleHelper
  def get_schedule_content
    #For schedule rendering
    @periods = Hash.new
    @user.subjects.each do | subject |
      subject.periods.each do | period |
        key = [period.day, period.time]
        #value = period.subject
        @periods[key] = subject
        end
    end
  end
end
