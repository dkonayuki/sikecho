class CreateSubjectsAndTeachersJoinTable < ActiveRecord::Migration
  def change
    create_table :subjects_teachers do |t|
        t.belongs_to :subject
        t.belongs_to :teacher
    end
  end
end
