class Users::RegistrationsController < Devise::RegistrationsController

  before_action :disable_nav, only: [:new, :create]
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  after_action :create_first_education, only: [:create]
  after_action :after_update, only: [:update]

  #override new action: sign up
  def new
    @universities = University.all
    super
  end

  #override create action: create new user
  def create
    @universities = University.all
    super
  end
  
  #override edit action
  def edit
    #education table is editable
    @isEditable = true
    super
  end
  
  #override update action
  def update
    @isEditable = true
    super
  end
  
  def after_update
    if resource.persisted? # user is created successfuly
      #destroy avatar if user remove
      if params[:avatar].blank? && resource.avatar.exists? 
        resource.avatar.clear
      end
      
      #update current education
      resource.settings(:education).current = Education.find(params[:current])
      resource.save!
    end
  end
  
  #set firt time education when create new user
  def create_first_education
    if resource.persisted? # user is created successfuly
      university = University.find(params[:university].to_i)
      education = Education.new(university: university)
      resource.educations << education
      resource.settings(:education).current = resource.educations.first
      resource.save!
    end
  end
  
  # The default url to be used after updating a resource. You need to overwrite
  # this method in your own RegistrationsController.
  def after_update_path_for(resource)
    #redirect to user's profile
    resource
  end
  
  # Never trust parameters from the scary internet, only allow the white list through.
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:username, :email, :password, :password_confirmation)}
    devise_parameter_sanitizer.for(:account_update) {|u| u.permit(:username, :nickname, :email, :password, :password_confirmation, :current_password, :avatar, :current)}
  end
  
  private :create_first_education, :configure_permitted_parameters
  
end