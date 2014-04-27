class Users::PasswordsController < Devise::PasswordsController
  
  before_action :disable_nav, only: [:new, :edit]
  before_action :configure_permitted_parameters

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:create) { |u| u.permit(:email, :username) }
  end
  
  private :configure_permitted_parameters
  
end
