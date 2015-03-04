class HomeController < ApplicationController
  def index
    #for @user in view
    if user_signed_in? 
      @user = current_user
      
      #only display activities from registered subjects and notes
      #deleted notes or subjects won't be displayed
      @activities = PublicActivity::Activity.order('created_at desc')
        .where('(trackable_id in (?) AND trackable_type = ?) OR (trackable_id in (?) AND trackable_type = ?)', @user.current_subjects.ids, 'Subject', @user.registered_notes.ids, 'Note')
        
      @activities = @activities.page(params[:page]).per(10)

    else
      redirect_to universities_url
    end
    
    #respond with js format, index.js.erb will be run
    respond_to do |format|
      format.html 
      format.js
    end
  end
  
end
