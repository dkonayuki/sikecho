class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_filter :authorize, only: [:new, :create, :faculty]
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
  
  def faculty
    @faculties = Faculty.where(university_id: params[:university_id]).order(:name)
    respond_to do |format|
      format.js { }
      format.html
      format.json
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
    @faculties = []
  end

  # GET /users/1/edit
  def edit
    @universities = University.all
    @faculties = Faculty.where(university_id: @user.university.id).order(:name)
  end

  # POST /users
  # POST /users.json
  def create
    #prepare previous info
    @universities = University.all

    @user = User.new(user_params)
    
    respond_to do |format|
      if @user.save
        #login
        session[:user_id] = @user.id
        format.html { redirect_to home_url, notice: 'User #{@user.username} was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        #prepare faculty select
        @faculties = @user.university_id ? Faculty.where(university_id: @user.university.id).order(:name) : []
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

    respond_to do |format|
      if @user.update(user_params) && @user.authenticate(user_params[:password_confirmation])
        format.html { redirect_to @user, notice: 'User #{@user.username} was successfully updated.' }
        format.json { head :ok }
      else
        #custom message for password_confirmation
        @user.errors.add(:password_confirmation, "doesn't match password.")
        #prepare faculty select
        @faculties = @user.university_id ? Faculty.where(university_id: @user.university.id).order(:name) : []
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
      params.permit(:university_id)
      params.require(:user).permit(:username, :password, :password_confirmation, :email, :university_id, :faculty_id)
    end
end
