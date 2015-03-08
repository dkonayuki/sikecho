class ActivitiesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    # activities index can be viewed in home page    
  end
  
  # GET /read
  def read
    PublicActivity::Activity.find(params[:id]).mark_as_read! for: current_user
    
    # only return http header
    # should be called from ajax in js
    head :no_content
  end
  
  # not in use now, maybe later
  def notification_count
    respond_to do |format|
      format.json { render json: { count: notifications.count } }
    end
  end
  
  # GET /refresh_notification_count
  def refresh_notification_count
    if user_signed_in?
      @notification_count = notifications.count
    else
      @notification_count = 0
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  # GET /refresh_notification_list
  # should be run after dropdown shown
  def refresh_notification_list
    if user_signed_in?
      @notifications = notifications
    
      respond_to do |format|
        format.js
      end
    end
  end
  
  # GET /mark_as_read_all
  def mark_as_read_all
    PublicActivity::Activity.mark_as_read! :all, for: current_user
    
    # only return http header
    # should be called from ajax in js
    head :no_content
  end
    
  private
    # get notifications for views
    def notifications
      @user = current_user
      
      #TODO need to select only activities that have created_at > register.created_at
      PublicActivity::Activity.unread_by(@user)
        .where('owner_id != ?', current_user.id)
        .where('(trackable_id in (?) AND trackable_type = ?)' +
          'OR (trackable_id in (?) AND trackable_type = ?)' +
          'OR (trackable_id in (?) AND trackable_type = ?)', @user.current_subjects.ids, 'Subject', @user.registered_notes.ids, 'Note', @user.registered_comments.ids, 'Comment')
        .order('created_at desc').limit(8)
    end
  
end
