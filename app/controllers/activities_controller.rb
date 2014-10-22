class ActivitiesController < ApplicationController
  def index
    @user = current_user
    @activities = PublicActivity::Activity.order('created_at desc')
      .where('(trackable_id in (?) AND trackable_type = ?) OR (trackable_id in (?) AND trackable_type = ?)', @user.current_subjects.ids, 'Subject', @user.registered_notes.ids, 'Note')
  end
end
