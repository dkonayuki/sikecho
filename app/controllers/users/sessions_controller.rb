class Users::SessionsController < Devise::SessionsController
  
  before_action :disable_nav, only: [:new]
  before_action :configure_permitted_parameters
  before_action :disable_university_select, only: [:new]
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
  end
  
  private :configure_permitted_parameters
  
end
