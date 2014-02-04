module ScheduleHelper
  def get_schedule_content
    #For schedule rendering
    @periods = Hash.new
    @user.periods.each do | period |
      key = [period.day, period.time]
      value = period.subject
      @periods[key] = period
    end
  end
end
