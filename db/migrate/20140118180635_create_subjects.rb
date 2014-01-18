class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
      t.string :name
      t.text :description
      t.string :subject_code
      t.integer :credit
      t.integer :term_id
      t.integer :course_id
      t.integer :teacher_id

      t.timestamps
    end
  end
end
