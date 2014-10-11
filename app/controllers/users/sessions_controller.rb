class Users::SessionsController < Devise::SessionsController
  
  before_action :disable_nav, only: [:new]
  before_action :configure_permitted_parameters
  before_action :disable_university_select, only: [:new]
  before_action :retrieve_user_from_session, only: [:new]
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me, :new) }
  end
  
  def retrieve_user_from_session
    #clear session user if new == true
    if params[:new]
      session[:user_id] = nil
    else
      #check if session user existed
      if !session[:user_id].blank?
        @session_user = User.find(session[:user_id])
      end
    end
  end
  
  private :configure_permitted_parameters, :retrieve_user_from_session
  
end
