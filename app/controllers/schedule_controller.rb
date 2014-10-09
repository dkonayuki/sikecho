class ScheduleController < ApplicationController
  
  before_action :set_user, only: [:show, :edit, :update, :destroy, :index, :new, :subjects, :create, :list_subjects_by_period]
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
  
  # GET /schedule/list_subjects_by_period
  def list_subjects_by_period
    @list_subjects = @user.current_subjects.joins(:periods).where(periods: {day: params[:day].to_i, time: params[:time].to_i})
    @day = params[:day].to_i
    @time = params[:time].to_i
  end
  
  def edit
  end
  
  # POST /schedule/:subject_id
  def create
    #add new subject
    subject = Subject.find_by_id(params[:subject_id].to_i)
    
    if @user.current_education.subjects.include?(subject) || !@user.current_university.subjects.include?(subject)
      status = :error
    else
      @user.current_education.subjects << subject unless @user.current_education.subjects.include?(subject)
      status = :ok    
    end
        
    #prepare view
    get_schedule_content
    @subjects = @user.current_university.subjects.search(params[:search]).page(params[:page]).per(4)
    @search = params[:search]
    @page = params[:page]
    
    respond_to do |format|    
      format.html { redirect_to schedule_path }
      format.js { render status: status }
      format.json { render json: {status: status } }
    end
  end

  # GET /schedule/
  def update
  end
  
  # DELETE /schedule/:subject_id
  def destroy
    subject = Subject.find_by_id(params[:subject_id].to_i)
    
    #delete subject education relationship
    if @user.current_education.subjects.include?(subject)
      @user.current_education.subjects.delete(subject)
      status = :ok
    else
      status = :error
    end
    
    #prepare view
    get_schedule_content
    @subjects = @user.current_university.subjects.search(params[:search]).page(params[:page]).per(4)
    @search = params[:search]
    @page = params[:page]
    
    respond_to do |format|    
      format.html { redirect_to schedule_path }
      format.js
      format.json { render json: {status: status } }
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def schedule_params
      params.permit(:day, :time, :search, :page, :subject_id)
    end  
end
