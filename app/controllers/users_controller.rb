class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_filter :authorize, only: [:new, :create, :faculty, :course]
  before_filter :disable_nav, only: [:new, :create]

  # GET /users
  # GET /users.json
  def index
    @users = User.order(:username)
    
    respond_to do |format|
      format.html 
      format.json { render json: @users }
    end
  end
  
  # get faculty list when university selection changed
  def faculty
    @faculties = Faculty.where(university_id: params[:university_id]).order(:name)
    @courses = []
    respond_to do |format|
      format.js
      format.html
    end
  end
  
  # get course list when faculty selection changed
  def course
    @courses = Course.where(faculty_id: params[:faculty_id]).order(:name)
    respond_to do |format|
      format.js
      format.html
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    get_schedule_content
    @editable = true
  end

  # GET /users/new
  def new
    @user = User.new
    @universities = University.all
    @faculties = Faculty.all
    @courses = Course.all
  end

  # GET /users/1/edit
  def edit
    @universities = University.all
    @faculties = Faculty.all
    @courses = Course.all    
    #@faculties = @user.university_id ? Faculty.where(university_id: @user.university.id).order(:name) : []
    #@courses = @user.faculty_id ? Course.where(faculty_id: @user.faculty.id).order(:name) : []
  end

  # POST /users
  # POST /users.json
  def create
    #prepare previous info
    @universities = University.all
    @faculties = Faculty.all
    @courses = Course.all  
    
    @user = User.new(user_params)
    
    respond_to do |format|
      if @user.save
        #login
        session[:user_id] = @user.id
        @user.settings(:education).current = @user.educations.first
        @user.save!

        format.html { redirect_to home_url, notice: 'User #{@user.username} was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        #prepare faculty and course select
        #@faculties = @user.university_id ? Faculty.where(university_id: @user.university.id).order(:name) : []
        #@courses = @user.faculty_id ? Course.where(faculty_id: @user.faculty.id).order(:name) : []
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    #prepare previous info
    @universities = University.all
    @faculties = Faculty.all
    @courses = Course.all
    
    respond_to do |format|
      if @user.authenticate(user_params[:password_confirmation]) && @user.update(user_params)
        format.html { redirect_to @user, notice: 'User #{@user.username} was successfully updated.' }
        format.json { head :ok }
      else
        #custom message for password_confirmation
        @user.errors.add(:password_confirmation, "doesn't match password.")
        #prepare faculty and course select
        #@faculties = @user.university_id ? Faculty.where(university_id: @user.university.id).order(:name) : []
        #@courses = @user.faculty_id ? Course.where(faculty_id: @user.faculty.id).order(:name) : []
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.permit(:university_id, :faculty_id)
      params.require(:user).permit(:username, :nickname, :password, :password_confirmation, :email, :avatar, educations_attributes: [:id, :university_id, :faculty_id, :course_id, :_destroy])
    end
end
