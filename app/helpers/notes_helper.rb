module NotesHelper
  
  #get unread notes count for view
  def unread_notes_count
    user = current_user
    #only from registered subjects notes
    Note.select('distinct notes.*').joins('INNER JOIN notes_subjects ON notes.id = notes_subjects.note_id')
      .joins('INNER JOIN subjects ON subjects.id = notes_subjects.subject_id')
      .joins('INNER JOIN registers ON registers.subject_id = subjects.id')
      .joins('INNER JOIN educations ON educations.id = registers.education_id')
      .where('educations.id = ?', user.current_education.id).unread_by(user).count
  end
  
  #get favorite notes count for view
  def favorite_notes_count
    current_user.favorites.notes.count
  end
  
  #get view content
  def prepare_view_content
    @subjects = current_university.subjects.order('notes_count DESC, year DESC')
  end
  
end
