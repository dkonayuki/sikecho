class HomeController < ApplicationController
  def index
    #for @user in view
    if user_signed_in? 
      @user = current_user
      
      #only display activities from registered subjects and notes
      #deleted notes or subjects won't be displayed
      #TODO need to select only activities that have created_at > register.created_at
      #@activities = PublicActivity::Activity
      #  .where('owner_id != ?', current_user.id)
      #  .where('(trackable_id in (?) AND trackable_type = ?)' +
      #    'OR (trackable_id in (?) AND trackable_type = ?)' +
      #    'OR (trackable_id in (?) AND trackable_type = ?)', @user.current_subjects.ids, 'Subject', @user.registered_notes.ids, 'Note', @user.registered_comments.ids, 'Comment')
      #  .order('created_at desc')
        
      @subject_activities = PublicActivity::Activity.select('distinct activities.*')
        .joins("INNER JOIN subjects ON ((subjects.id = trackable_id) AND (trackable_type = 'Subject'))")
        .joins('INNER JOIN registers ON ((registers.subject_id = subjects.id) AND (registers.created_at < activities.created_at))')
        .joins('INNER JOIN educations ON educations.id = registers.education_id')
        .joins('INNER JOIN users ON users.id = educations.current_user_id')
        .where('users.id = ? AND owner_id != ?', @user.id, @user.id)

      @note_activities = PublicActivity::Activity.select('distinct activities.*')
        .joins("INNER JOIN notes ON ((notes.id = trackable_id) AND (trackable_type = 'Note'))")
        .joins('INNER JOIN notes_subjects ON notes_subjects.note_id = @notes.id')
        .joins("INNER JOIN subjects ON @subjects.id = notes_subjects.subject_id")
        .joins('INNER JOIN registers ON ((registers.subject_id = subjects.id) AND (registers.created_at < activities.created_at) AND (registers.created_at < notes.updated_at))')
        .joins('INNER JOIN educations ON educations.id = registers.education_id')
        .joins('INNER JOIN users ON users.id = educations.current_user_id')
        .where('users.id = ? AND owner_id != ?', @user.id, @user.id)
        
      @comment_activities = PublicActivity::Activity.select('distinct activities.*')
        .joins("INNER JOIN comments ON ((comments.id = trackable_id) AND (trackable_type = 'Comment'))")
        .joins("INNER JOIN documents ON ((documents.id = comments.commentable_id) AND (comments.commentable_type = 'Document'))")
        .joins("INNER JOIN notes ON notes.id = documents.note_id")
        .joins('INNER JOIN notes_subjects ON notes_subjects.note_id = @notes.id')
        .joins("INNER JOIN subjects ON @subjects.id = notes_subjects.subject_id")
        .joins('INNER JOIN registers ON ((registers.subject_id = subjects.id) AND (registers.created_at < activities.created_at) AND (registers.created_at < comments.created_at))')
        .joins('INNER JOIN educations ON educations.id = registers.education_id')
        .joins('INNER JOIN users ON users.id = educations.current_user_id')
        .where('users.id = ? AND owner_id != ?', @user.id, @user.id)
      
      #wait for ActiveRecord 5.0 to be able to merge 2 relations with #OR arthime
      #https://github.com/rails/rails/commit/9e42cf019f2417473e7dcbfcb885709fa2709f89
      @activities = @subject_activities + @note_activities + @comment_activities
      @activities.sort_by! { |a| a.created_at }.reverse!
      
      #kaminari pagination, page param can be nil
      @activities = Kaminari.paginate_array(@activities).page(params[:page]).per(10)
      
      #mark as read if link from notification menu
      if !params[:mark_as_read].blank? && params[:mark_as_read].to_i == 1
        PublicActivity::Activity.mark_as_read! :all, for: @user
      end
      
      #latest notes
      @notes = @user.registered_notes.order('created_at DESC').limit(5)
    else
      #not signed in
      redirect_to universities_url
    end
  end
  
end
