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
      @notifications = notifications.first(8)
    
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
      
      #select only activities that have created_at > register.created_at
      subject_activities = PublicActivity::Activity.unread_by(@user).select('distinct activities.*')
        .joins("INNER JOIN subjects ON ((subjects.id = trackable_id) AND (trackable_type = 'Subject'))")
        .joins('INNER JOIN registers ON ((registers.subject_id = subjects.id) AND (registers.created_at < activities.created_at))')
        .joins('INNER JOIN educations ON educations.id = registers.education_id')
        .joins('INNER JOIN users ON users.id = educations.current_user_id')
        .where('users.id = ? AND owner_id != ?', @user.id, @user.id)

      note_activities = PublicActivity::Activity.unread_by(@user).select('distinct activities.*')
        .joins("INNER JOIN notes ON ((notes.id = trackable_id) AND (trackable_type = 'Note'))")
        .joins('INNER JOIN notes_subjects ON notes_subjects.note_id = @notes.id')
        .joins("INNER JOIN subjects ON @subjects.id = notes_subjects.subject_id")
        .joins('INNER JOIN registers ON ((registers.subject_id = subjects.id) AND (registers.created_at < activities.created_at) AND (registers.created_at < notes.updated_at))')
        .joins('INNER JOIN educations ON educations.id = registers.education_id')
        .joins('INNER JOIN users ON users.id = educations.current_user_id')
        .where('users.id = ? AND owner_id != ?', @user.id, @user.id)
        
      comment_activities = PublicActivity::Activity.unread_by(@user).select('distinct activities.*')
        .joins("INNER JOIN comments ON ((comments.id = trackable_id) AND (trackable_type = 'Comment'))")
        .joins("INNER JOIN documents ON ((documents.id = comments.commentable_id) AND (comments.commentable_type = 'Document'))")
        .joins("INNER JOIN notes ON notes.id = documents.note_id")
        .joins('INNER JOIN notes_subjects ON notes_subjects.note_id = @notes.id')
        .joins("INNER JOIN subjects ON @subjects.id = notes_subjects.subject_id")
        .joins('INNER JOIN registers ON ((registers.subject_id = subjects.id) AND (registers.created_at < activities.created_at) AND (registers.created_at < comments.created_at))')
        .joins('INNER JOIN educations ON educations.id = registers.education_id')
        .joins('INNER JOIN users ON users.id = educations.current_user_id')
        .where('users.id = ? AND owner_id != ?', @user.id, @user.id)
      
      #TODO wait for ActiveRecord 5.0 to be able to merge 2 relations with #OR arthime
      #https://github.com/rails/rails/commit/9e42cf019f2417473e7dcbfcb885709fa2709f89
      activities = subject_activities + note_activities + comment_activities
      activities.sort_by! { |a| a.created_at }.reverse!
    end
  
end
