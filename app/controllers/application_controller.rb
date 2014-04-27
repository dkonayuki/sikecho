class ApplicationController < ActionController::Base
  before_action :authenticate_user!, :set_no_cache
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include ApplicationHelper
  include ScheduleHelper
  
  def disable_nav
    @disable_nav = true
  end
  
  def set_no_cache
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
  
  # for /tags.json
  def tags
    @tags = ActsAsTaggableOn::Tag.all
    respond_to do |format|
      format.json { render json: @tags }
    end
  end
  
  # get faculty list when university selection changed
  def faculties
    @faculties = Faculty.where(university_id: params[:university_id]).order(:name)
    @courses = []
    respond_to do |format|
      format.json { render json: @faculties }
    end
  end
  
  # get course list when faculty selection changed
  def courses
    @courses = Course.where(faculty_id: params[:faculty_id]).order(:name)
    respond_to do |format|
      format.json { render json: @courses }
    end
  end
  
  # get new uni_year list when university changes
  def uni_years
    @uni_years = UniYear.where(university_id: params[:university_id])
 
    respond_to do |format|
      format.json { render json: @uni_years }
    end
  end
    
  # get new semester list when uni_year changes
  def semesters
    uni_year = UniYear.find_by_id(params[:uni_year_id])
    @semesters = uni_year ? uni_year.semesters : []
 
    respond_to do |format|
      format.json { render json: @semesters }
    end
  end

  private :disable_nav

end