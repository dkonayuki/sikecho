class NotesSubject < ActiveRecord::Base
  # this model uses table "notes_subjects" as it is
  # column notes_count is in the table "subjects"
  # store number of notes in subjects table
  belongs_to :subject, counter_cache: :notes_count
  belongs_to :note
end