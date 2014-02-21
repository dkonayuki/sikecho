class ApplicationController < ActionController::Base
  before_filter :authorize, :current_user, :set_no_cache
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include ApplicationHelper
  include ScheduleHelper
    
  private 
  def current_user
    @user = User.find_by_id(session[:user_id])
    @user
  end
    
  private
  def authorize
    unless User.find_by_id(session[:user_id])
      redirect_to login_url, notice: "Please login"
    end
  end
  
  private
  def disable_nav
    @disable_nav = true
  end
  
  def set_no_cache
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

end