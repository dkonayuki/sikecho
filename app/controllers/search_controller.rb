class SearchController < ApplicationController
  def search
    @user = current_user
    
    #search subjects and notes
    @subjects = @user.current_university.subjects.search(params[:query])
    @notes = @user.current_university.notes.search(params[:query])
    
    #prepare instance variable for view
    @type = params[:type]
    @query = params[:query]
    
    #custom show
    @show_course = true
    @show_subject = true
    
    respond_to do |format|
      format.html 
      format.js   
    end
  end
end
