module ScheduleHelper
  def get_schedule_content
    #For schedule rendering
    @periods = Hash.new
    @user = current_user
    1.upto(Period::MAX_DAY).each do | d | 
      1.upto(Period::MAX_TIME).each do | t |
        key = [d, t]
        @periods[key] = @user.current_subjects.joins(:periods).where(periods: {day: d, time: t}) || []
        # => @periods[key] = @user.subjects.joins(:periods).where(periods: {day: d, time: t})
      end
    end
  end
end
