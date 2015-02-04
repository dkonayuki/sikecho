class CreateNotesAndSubjectsJoinTable < ActiveRecord::Migration
  def change
    create_table :notes_subjects do |t|
      t.belongs_to :note, index: true
      t.belongs_to :subject, index: true
    end
  end
end
