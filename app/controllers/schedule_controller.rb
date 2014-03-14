class ScheduleController < ApplicationController
  def index
    @user = current_user
    
    #prepare view
    get_schedule_content
    @subjects = @user.faculty.subjects.search(params[:search]).page(params[:page]).per(4)
    @search = params[:search]
    @page = params[:page]
    
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
  end
  
  # POST /schedule/:subject
  def create
    @user = current_user

    #add new subject
    subject = @user.faculty.subjects.find_by_id(params[:subject].to_i)
    @user.subjects << subject unless @user.subjects.include?(subject)
        
    #prepare view
    get_schedule_content
    @subjects = @user.faculty.subjects.search(params[:search]).page(params[:page]).per(4)
    @search = params[:search]
    @page = params[:page]
    
    respond_to do |format|    
      format.html { redirect_to schedule_path }
      format.js   {}
    end
  end

  def update
  end
  
  # DELETE /schedule/:subject
  def destroy
    @user = current_user
    
    #delete subject user relationship
    @user.subjects.delete(@user.faculty.subjects.find_by_id(params[:subject].to_i))
    
    #prepare view
    get_schedule_content
    @subjects = @user.faculty.subjects.search(params[:search]).page(params[:page]).per(4)
    @search = params[:search]
    @page = params[:page]
    
    respond_to do |format|    
      format.html { redirect_to schedule_path }
      format.js   {}
    end
  end
  
end
