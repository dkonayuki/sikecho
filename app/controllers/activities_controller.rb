class ActivitiesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @user = current_user
    
    #only display activities from registered subjects and notes
    #deleted notes or subjects won't be displayed
    @activities = PublicActivity::Activity.order('created_at desc')
      .where('(trackable_id in (?) AND trackable_type = ?) OR (trackable_id in (?) AND trackable_type = ?)', @user.current_subjects.ids, 'Subject', @user.registered_notes.ids, 'Note')
  end
end
