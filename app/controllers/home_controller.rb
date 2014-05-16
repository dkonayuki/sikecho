class HomeController < ApplicationController
  def index
    if current_university == nil
      @universities = University.all
    else
      @university = current_university
    end

    if user_signed_in? 
      @user = current_user
      get_schedule_content
    end
  end
end
