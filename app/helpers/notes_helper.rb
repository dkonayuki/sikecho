module NotesHelper
  
  #get unread notes count for view
  def unread_notes_count
    user = current_user
    user.current_university.notes.unread_by(user).count
  end
  
end
