class ScheduleController < ApplicationController
  
  before_action :set_user, only: [:show, :edit, :update, :destroy, :index, :new, :subject, :create]
  before_action :authenticate_user!
  
  def index
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
    @subjects = @user.current_university.subjects.joins(:periods).where(periods: {day: params[:day].to_i, time: params[:time].to_i})
  end
  
  # GET /schedule/subject.json
  def subject
    subjects = @user.current_subjects.joins(:periods).where(periods: {day: params[:day].to_i, time: params[:time].to_i})
    respond_to do |format|
      format.json { render json: subjects }
    end
  end
  
  def edit
  end
  
  # POST /schedule/:subject
  def create
    #add new subject
    subject = Subject.find_by_id(params[:subject].to_i)
    @user.current_education.subjects << subject
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
    
    #delete subject education relationship
    @user.current_education.subjects.delete(Subject.find_by_id(params[:subject].to_i))
    
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
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def schedule_params
      params.permit(:day, :time, :search, :page)
    end  
end
