class HomeController < ApplicationController
  def index
    #for @user in view
    if user_signed_in? 
      @user = current_user
      
      #only display activities from registered subjects and notes
      #deleted notes or subjects won't be displayed
      #FIXME
      @activities = PublicActivity::Activity
        .where('(trackable_id in (?) AND trackable_type = ?)' +
          'OR (trackable_id in (?) AND trackable_type = ?)' +
          'OR (trackable_id in (?) AND trackable_type = ?)', @user.current_subjects.ids, 'Subject', @user.registered_notes.ids, 'Note', @user.registered_comments.ids, 'Comment')
        .order('created_at desc')
        
      #kaminari pagination, page param can be nil
      @activities = @activities.page(params[:page]).per(10)

      #latest notes
      @notes = @user.registered_notes.order('created_at DESC').limit(5)
      @notes.mark_as_read! :all, for: @user
          #@note.mark_as_read! for: @user
    else
      redirect_to universities_url
    end
  end
  
end
