class HomeController < ApplicationController
  def index
    @user = current_user
    @number_of_notes = @user.notes.count
    
    get_schedule_content
    @editable = false
  end
end
