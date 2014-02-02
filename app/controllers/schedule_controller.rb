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
  end
  
  def create
  end

  def update
  end
  
  def destroy
  end
end
