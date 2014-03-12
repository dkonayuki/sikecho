class ScheduleController < ApplicationController
  def index
    @user = current_user
    get_schedule_content
    @editable = true
    @subjects = @user.faculty.subjects.search(params[:search]).page(params[:page]).per(4)
    @search = params[:search]
    respond_to do |format|
      format.html {}
      format.js   {}
      format.json { render json: @subjects, status: :ok, location: :subjects }
    end
  end

  # GET /schedule/new
  def new
    @user = current_user
    @subjects = @user.faculty.subjects.joins(:periods).where(periods: {day: params[:day].to_i, time: params[:time].to_i})
  end
  
  def edit
    @user = current_user
    @subjects = @user.faculty.subjects.joins(:periods).where(periods: {day: params[:day].to_i, time: params[:time].to_i})

    @subject = @subjects.find_by_id(params[:subject].to_i)
  end
  
  # PUT /schedule/new
  # params[:subject, :old_subject]
  def create
    @user = current_user 
    @user.subjects << @user.faculty.subjects.find_by_id(params[:subject].to_i)
    
    redirect_to schedule_path
  end

  def update
    @user = current_user 
    subjects = @user.faculty.subjects.all
    #delete old subject and create a new one
    @user.subjects.delete(subjects.find_by_id(params[:old_subject].to_i))
    @user.subjects << subjects.find_by_id(params[:subject].to_i)
    
    redirect_to schedule_path
  end
  
  def destroy
    @user = current_user
    #delete subject user relationshp
    @user.subjects.delete(@user.faculty.subjects.find_by_id(params[:subject].to_i))
    redirect_to schedule_path
  end
  
end
