class HomeController < ApplicationController
  def index
    @user = current_user
    
    get_schedule_content
    @editable = false
  end
end
