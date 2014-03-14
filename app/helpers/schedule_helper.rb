module ScheduleHelper
  def get_schedule_content
    #For schedule rendering
    @periods = Hash.new
    @user = current_user
    (0..5).each do | d | 
      (0..6).each do | t |
        key = [d, t]
        @periods[key] = []
        @periods[key] = @user.subjects.joins(:periods).where(periods: {day: d, time: t})
      end
    end
  end
end
