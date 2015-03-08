class Comment < ActiveRecord::Base
  #for custom activity
  include PublicActivity::Common

  validates :content, presence: true, length: 4..150

  belongs_to :user
  belongs_to :commentable, polymorphic: true
  
  # get users who are related to this comment
  def registered_users
    User.select('distinct users.*')
      .joins('INNER JOIN educations ON educations.current_user_id = users.id')
      .joins('INNER JOIN registers ON registers.education_id = educations.id')
      .joins('INNER JOIN subjects ON subjects.id = registers.subject_id')
      .joins('INNER JOIN notes_subjects ON notes_subjects.subject_id = subjects.id')
      .joins('INNER JOIN notes ON notes.id = notes_subjects.note_id')
      .joins('INNER JOIN documents ON documents.note_id = notes.id')
      .joins("INNER JOIN comments ON (comments.commentable_id = documents.id AND comments.commentable_type = 'Document')")
      .where('comments.id = ?', self.id)
  end
end
