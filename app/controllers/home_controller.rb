class HomeController < ApplicationController
  def index
    #for @user in view
    if user_signed_in? 
      @user = current_user
      
      #only display activities from registered subjects and notes
      #deleted notes or subjects won't be displayed
      #TODO need to select only activities that have created_at > register.created_at
      @activities = PublicActivity::Activity
        .where('owner_id != ?', current_user.id)
        .where('(trackable_id in (?) AND trackable_type = ?)' +
          'OR (trackable_id in (?) AND trackable_type = ?)' +
          'OR (trackable_id in (?) AND trackable_type = ?)', @user.current_subjects.ids, 'Subject', @user.registered_notes.ids, 'Note', @user.registered_comments.ids, 'Comment')
        .order('created_at desc')
        
      #kaminari pagination, page param can be nil
      @activities = @activities.page(params[:page]).per(10)
      
      #mark as read if link from notification menu
      if !params[:mark_as_read].blank? && params[:mark_as_read].to_i == 1
        @activities.mark_as_read! :all, for: @user
      end
      
      #latest notes
      @notes = @user.registered_notes.order('created_at DESC').limit(5)
    else
      #not signed in
      redirect_to universities_url
    end
  end
  
end
