class ScheduleController < ApplicationController
  def index
    @user = current_user
    @periods = Hash.new
    @user.periods.each do | period |
      key = [period.day, period.time]
      value = period.subject
      @periods[key] = value
    end
  end

  def edit
  end

  def new
    @period = Period.new
    @subjects = Subject.all
    time_names = %w(一時限 二時限 三時限 四時限 五時限 六時限)
    day_names = %w(月曜日 火曜日 水曜日 木曜日 金曜日 土曜日)
    @period.time = params[:time].to_i
    @period.time_name = time_names[ params[:time].to_i ]
    @period.day = params[:day].to_i
    @period.day_name = day_names[ params[:day].to_i]
  end
  
  def create
  end

  def update
  end
  
  def destroy
  end
end
