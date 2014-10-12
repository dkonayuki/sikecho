class ApplicationController < ActionController::Base
  before_action :set_no_cache
  before_action :set_subdomain
  before_action :set_locale
  
  #Can't verify CSRF token authenticity issue
  skip_before_action  :verify_authenticity_token
  #before_action :authenticate_user!
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  include ApplicationHelper
  include ScheduleHelper
  
  # handle unauthorized access
  rescue_from CanCan::AccessDenied do |exception|
    render file: "#{Rails.root}/public/422.html", :status => 403, layout: false
    #redirect_to new_user_session_url, alert: exception.message
  end
  
  # redirect to 404 page
  def not_found
    render file: 'public/404.html', status: :not_found, layout: false
  end
  
  # handle record not found
  rescue_from ActiveRecord::RecordNotFound do |exception|
    not_found
  end
  
  def set_locale
    I18n.locale = params[:locale] || session[:locale] || I18n.default_locale
    
    #update session
    session[:locale] = I18n.locale
    #I18n.locale = current_user.locale if user_signed_in?
    # current_user.locale
    # request.domain
    # request.env["HTTP_ACCEPT_LANGUAGE"]
    # request.remote_ip
  end
  
  def default_url_options(options = {})
    options.merge({ locale: ((I18n.locale == I18n.default_locale) ? nil : I18n.locale) })
    #options.merge({ locale: I18n.locale})
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
  
  # redirect after sign in
  def after_sign_in_path_for(resource)
    case resource
    when User then
      #store session user for gmail style login
      session[:user_id] = current_user.id
      #remember to use url for changing subdomain
      #stored_location_for(resource) will store the last location b4 login
      request.env['omniauth.origin'] || stored_location_for(resource) || root_url(subdomain: resource.current_education.university.codename)
    when Admin then
      rails_admin_path
    end
  end
  
  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    #remember to use url for changing subdomain
    new_user_session_url(subdomain: nil)
  end
  
  # Always use the appropriate subdomain for user
  def set_subdomain
    if user_signed_in? && current_user.current_university != current_university
      redirect_to subdomain: current_user.current_university.codename
    end
  end
  
  private :disable_nav
  private :set_locale

end