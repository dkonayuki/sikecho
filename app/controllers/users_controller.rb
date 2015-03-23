class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  load_and_authorize_resource only: [:index, :show, :new, :edit, :destroy]

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
  end

  # GET /users/new
  def new
  #use registrations_controller
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
  #use registrations_controller
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
  #use registrations_controller
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
      if params[:id].nil? # if there is no user id in params, show current one
        @user = current_user
      else # if there is the user id in params just use it, 
        # only show profile belongs to appropriate subdomain/university
        @user = current_university.users.find(params[:id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      # dont need params here
      # params will be handled in registrations controller
      params.require(:user).permit()
    end
end
