class ScheduleController < ApplicationController
  
  before_action :authenticate_user!
  
  def index
    @user = current_user
    
    #prepare view
    get_schedule_content
    @subjects = @user.current_university.subjects.search(params[:search]).page(params[:page]).per(4)
    
    #for add/remove consistency
    @search = params[:search]
    @page = params[:page]
    
    respond_to do |format|
      format.html 
      format.js
    end
  end

  # GET /schedule/new
  def new
    @user = current_user
    @subjects = @user.current_university.subjects.joins(:periods).where(periods: {day: params[:day].to_i, time: params[:time].to_i})
  end
  
  def edit
  end
  
  # POST /schedule/:subject
  def create
    @user = current_user

    #add new subject
    subject = Subject.find_by_id(params[:subject].to_i)
    @user.current_education.periods << subject.periods.to_a
    #need to fix @user.subjects << subject unless @user.subjects.include?(subject)
        
    #prepare view
    get_schedule_content
    @subjects = @user.current_university.subjects.search(params[:search]).page(params[:page]).per(4)
    @search = params[:search]
    @page = params[:page]
    
    respond_to do |format|    
      format.html { redirect_to schedule_path }
      format.js 
    end
  end

  def update
  end
  
  # DELETE /schedule/:subject
  def destroy
    @user = current_user
    
    #delete subject user relationship
    @user.current_education.periods.delete(Subject.find_by_id(params[:subject].to_i).periods)
    
    #prepare view
    get_schedule_content
    @subjects = @user.current_university.subjects.search(params[:search]).page(params[:page]).per(4)
    @search = params[:search]
    @page = params[:page]
    
    respond_to do |format|    
      format.html { redirect_to schedule_path }
      format.js
    end
  end
  
end
