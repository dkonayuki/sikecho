class HomeController < ApplicationController
  def index
    #for @user in view
    if user_signed_in? 
      @user = current_user
      @activities = PublicActivity::Activity.order('created_at desc')
        .where('(trackable_id in (?) AND trackable_type = ?) OR (trackable_id in (?) AND trackable_type = ?)', @user.current_subjects.ids, 'Subject', @user.registered_notes.ids, 'Note')
    else
      @universities = University.all
    end
  end
end
