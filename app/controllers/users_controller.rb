class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_filter :authorize, only: [:new, :create]
  before_filter :disable_nav, only: [:new]

  # GET /users
  # GET /users.json
  def index
    @users = User.order(:username)
    
    respond_to do |format|
      format.html 
      format.json { render json: @users }
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
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @universities = University.all
    @faculties = Faculty.all    
    @user = User.new(user_params.except(:university, :faculty))
    @user.university = University.find(user_params[:university])
    @user.faculty = Faculty.find(user_params[:faculty])

    respond_to do |format|
      if @user.save
        format.html { redirect_to home_url, notice: 'User #{@user.username} was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        disable_nav
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User #{@user.name} was successfully updated.' }
        format.json { head :ok }
      else
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
      params.require(:user).permit(:username, :password, :password_confirmation, :email, :university, :faculty)
    end
end
