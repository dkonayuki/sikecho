class SearchController < ApplicationController
  def search
    @user = current_user
    @subjects = @user.university.subjects.search(params[:query])
    @notes = @user.university.notes.search(params[:query])
    puts @notes.count
    puts @notes.inspect
    @type = params[:type]
    @query = params[:query]
    
    respond_to do |format|
      format.html 
      format.js   
    end
  end
end
