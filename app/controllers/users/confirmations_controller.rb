class Users::ConfirmationsController < Devise::ConfirmationsController
  
  before_action :disable_nav, only: [:new]
  before_action :configure_permitted_parameters

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:create) { |u| u.permit(:email, :username) }
  end
  
  private :configure_permitted_parameters
  
end
