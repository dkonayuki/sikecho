class ScheduleController < ApplicationController
  
  before_action :set_user, only: [:show, :edit, :update, :destroy, :index, :new, :subjects, :create, :list_subjects_by_period]
  before_action :authenticate_user!
  
  def index
    #prepare view
    get_schedule_content
    @subjects = @user.current_university.subjects.search(params[:search]).page(params[:page]).per(4)
    
    #default order option
    @subjects = @subjects.ordered
    
    #for add/remove consistency
    @search = params[:search]
    @page = params[:page]
    @view_option = params[:view_option].to_i || 0
    
    respond_to do |format|
      format.html 
      format.js
    end
  end

  # GET /schedule/new
  def new
  end
  
  # GET /schedule/view_option
  def view_option
    @view_option = params[:view_option].to_i
    get_schedule_content
     
    respond_to do |format|
      format.js
    end
  end
  
  def edit
  end
  
  # POST /schedule/:subject_id
  def create
    #add new subject
    subject = Subject.find_by_id(params[:subject_id].to_i)
    
    if @user.registered?(subject) || !@user.current_university.subjects.include?(subject)
      status = :error
    else
      #add new subject with created_at time store in register table
      #created_at attribute is automatically created
      @user.current_education.registers.create(subject: subject)
      status = :ok
    end
    
    #prepare view
    get_schedule_content
    @subjects = @user.current_university.subjects.search(params[:search]).page(params[:page]).per(4)
    
    #default order option
    @subjects = @subjects.order('year DESC, name ASC, view_count DESC')

    #for add/remove consistency
    @search = params[:search]
    @page = params[:page]
    @view_option = params[:view_option].to_i || 0
    
    respond_to do |format|
      format.html { redirect_to schedule_path }
      format.js
      format.json { render json: { status: status } } #for subject index and subject show page
    end
  end

  # GET /schedule/
  def update
  end
  
  # DELETE /schedule/:subject_id
  def destroy
    subject = Subject.find_by_id(params[:subject_id].to_i)
    
    #delete subject education relationship
    if @user.registered?(subject)
      @user.current_education.subjects.delete(subject)
      status = :ok
    else
      status = :error
    end
    
    #prepare view
    get_schedule_content
    @subjects = @user.current_university.subjects.search(params[:search]).page(params[:page]).per(4)
    
    #default order option
    @subjects = @subjects.order('year DESC, name ASC, view_count DESC')
    
    #for add/remove consistency
    @search = params[:search]
    @page = params[:page]
    @view_option = params[:view_option].to_i || 0
    
    respond_to do |format|    
      format.html { redirect_to schedule_path }
      format.js
      format.json { render json: {status: status } } #for subject index and subject show page
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def schedule_params
      params.permit(:day, :time, :search, :page, :subject_id, :view_option)
    end  
end
