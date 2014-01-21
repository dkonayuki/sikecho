class HomeController < ApplicationController
  def index
    @user = current_user
    @number_of_notes = @user.notes.count
  end
end
