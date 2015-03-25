class Users::RegistrationsController < Devise::RegistrationsController

  before_action :disable_nav, only: [:new, :create]
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :disable_university_select, only: [:new, :create]
  
  #override new action: sign up
  def new
    @universities = University.all
    super
  end
  
  #override edit action
  def edit
    #authorize cancan
    authorize! :edit, resource
    
    #education table is editable
    @isEditable = true
    super
  end
  
  # override create action
  # POST /resource
  def create
    @universities = University.all
    build_resource(sign_up_params)

    resource_saved = resource.save
    yield resource if block_given?
    if resource_saved
        
      #set firt time education when create new user
      university = University.find(params[:university].to_i)
      education = Education.create(university: university)
      resource.educations << education
      resource.current_education = education
      resource.save!
        
      if resource.active_for_authentication?
        
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end
  
  # override update action
  def update
    @isEditable = true
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      
      #delete avatar
      #present? is equivalent to !blank?
      if params[:remove_avatar].present? && params[:remove_avatar].to_i == 1
        if resource.avatar.present? 
          resource.avatar.destroy
          resource.save!
        end
      end
      
      #update current education
      if params[:current_education].present?
        resource.current_education = Education.find(params[:current_education])
        resource.save!
      end
      
      #update settings public or not
      if params[:education_public].present?
        resource.settings(:education).public = params[:education_public].to_i
        resource.save
      end
      
      sign_in resource_name, resource, bypass: true
      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      # temporally redirect to the same location
      respond_with resource, location: after_update_path_for(resource)
    end
  end
  
  # The default url to be used after updating a resource. You need to overwrite
  # this method in your own RegistrationsController.
  def after_update_path_for(resource)
    #redirect to user's profile
    #remember to use url for changing subdomain
    profile_url(subdomain: resource.current_education.university.codename)
    #resource
  end
  
  # Never trust parameters from the scary internet, only allow the white list through.
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:username, :email, :password, :password_confirmation)}
    devise_parameter_sanitizer.for(:account_update) {|u| u.permit(:username, :nickname, :email, :password, :password_confirmation, :current_password, :avatar)}
  end
  
  private :configure_permitted_parameters
  
end