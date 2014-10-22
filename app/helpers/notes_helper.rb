module NotesHelper
  
  #get unread notes count for view
  def unread_notes_count
    user = current_user
    Note.select('distinct notes.*').joins('INNER JOIN notes_subjects ON notes.id = notes_subjects.note_id')
      .joins('INNER JOIN subjects ON subjects.id = notes_subjects.subject_id')
      .joins('INNER JOIN educations_subjects ON educations_subjects.subject_id = subjects.id')
      .joins('INNER JOIN educations ON educations.id = educations_subjects.education_id')
      .where('educations.id = ?', user.current_education.id).unread_by(user).count
  end
  
end
