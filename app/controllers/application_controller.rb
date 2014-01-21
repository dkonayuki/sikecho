class ApplicationController < ActionController::Base
  before_filter :authorize, :current_user
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
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
  
end