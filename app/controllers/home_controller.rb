class HomeController < ApplicationController
  def index
    @user = current_user
    
    if user_signed_in? 
      get_schedule_content
    end
  end
end
