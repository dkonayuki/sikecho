class HomeController < ApplicationController
  def index
    if current_university == nil
      @universities = University.all
    else
      @university = current_university
    end

    #for @user in view
    if user_signed_in? 
      @user = current_user
    end
  end
end
