class HomeController < ApplicationController
  def index
    if current_university == nil
      @universities = University.all
    else
      @university = current_university
    end

    #for @user in view
    if user_signed_in? 
      @user = current_user
      @activities = PublicActivity::Activity.order('created_at desc')
        .where('(trackable_id in (?) AND trackable_type = ?) OR (trackable_id in (?) AND trackable_type = ?)', @user.current_subjects.ids, 'Subject', @user.registered_notes.ids, 'Note')
    end
  end
end
