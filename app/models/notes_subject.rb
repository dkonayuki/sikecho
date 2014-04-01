class NotesSubject < ActiveRecord::Base
  # this model uses table "notes_subjects" as it is
  # column notes_count is in the table "subjects"
  belongs_to :subject, counter_cache: :notes_count
  belongs_to :note
end