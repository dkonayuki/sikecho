class ScheduleController < ApplicationController
  def index
    get_schedule_content
    @editable = true
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
  
  def edit
    @period = Period.find( params[:id] )
    @subjects = Subject.all
  end
  
  def create
    @user = current_user 
    @period = Period.new( period_params )

    @period.subject = Subject.find( params[:subject].to_i )
    @period.user = @user
    @period.save()
    puts @period.time
    puts @period.time_name
    puts @period.day
    puts @period.day_name
    redirect_to @user
  end

  def update
  end
  
  def destroy
    @period = Period.find( params[:id])
    @period.destroy
    redirect_to @user
  end
  
  private

  def period_params
    params.require(:period).permit(:time, :time_name, :day, :day_name, :subject)
  end
end
