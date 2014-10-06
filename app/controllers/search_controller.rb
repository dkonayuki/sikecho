class SearchController < ApplicationController
  def search
    @user = current_user
    
    #search subjects
    @subjects = current_university.subjects.search(params[:q]).limit(7)
    
    #custom show
    @show_course = true
    
    respond_to do |format|
      format.html
      format.js
      format.json { render json: @subjects.to_json(only: [:name], 
          methods: [:typeahead_thumbnail, :typeahead_subject_path], 
          include: {teachers: {only: [], methods: [:full_name]}}
          )
        }
    end
  end
end
