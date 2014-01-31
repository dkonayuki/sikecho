class CreateNotesAndSubjectsJoinTable < ActiveRecord::Migration
  def change
    create_table :notes_subjects do |t|
      t.belongs_to :note
      t.belongs_to :subject
    end
  end
end
