class HomeController < ApplicationController
  def index
    #for @user in view
    if user_signed_in? 
      @user = current_user
      
      #only display activities from registered subjects and notes
      #deleted notes or subjects won't be displayed
      @activities = PublicActivity::Activity.select('distinct activities.*')
        .where('(trackable_id in (?) AND trackable_type = ?) OR (trackable_id in (?) AND trackable_type = ?)', @user.current_subjects.ids, 'Subject', @user.registered_notes.ids, 'Note')
        .order('created_at desc')
      #@activities = PublicActivity::Activity.order('created_at desc').where("trackable_type = 'Comment'")
      #TODO


      
      #kaminari pagination, page param can be nil
      @activities = @activities.page(params[:page]).per(10)
      
      #latest notes
      @notes = @user.registered_notes.order('created_at DESC').limit(5)
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
