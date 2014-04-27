class SessionsController < ApplicationController
  skip_before_filter :authorize
  before_filter :disable_nav, only: [:new]

  def new
  end

  def create
    user = User.find_by_username(params[:username]) || User.find_by_email(params[:username])
    #login by email
    
    if user and user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to home_url
    else 
      redirect_to login_url, alert: "Wrong password or username!"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to home_path, notice: "Logged out"
  end
end
