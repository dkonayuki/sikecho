class SearchController < ApplicationController
  # is needed for typeahead in header
  # when user type in keyword, search controller will return json
  # to generate subject list on the view
  def search
    @user = current_user
    
    #search subjects
    @subjects = current_university.subjects.search(params[:q]).limit(7)
    
    #custom show
    @show_course = true
    
    respond_to do |format|
      format.html
      format.js
      format.json { render json: @subjects.to_json(only: [:name, :year], 
          methods: [:typeahead_thumbnail, :typeahead_subject_path], # put methods to json attribute
          include: {teachers: {only: [], methods: [:full_name]}} # include teacher's attributes
          )
        }
    end
  end
end
