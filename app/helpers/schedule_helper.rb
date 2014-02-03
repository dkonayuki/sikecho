module ScheduleHelper
  def get_schedule_content
    #For schedule rendering
    @user = current_user
    @periods = Hash.new
    puts 'helperrrrrrrrr'
    @user.periods.each do | period |
      key = [period.day, period.time]
      value = period.subject
      @periods[key] = value
    end
  end
end
