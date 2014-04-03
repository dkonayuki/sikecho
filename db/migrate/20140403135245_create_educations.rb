class CreateEducations < ActiveRecord::Migration
  def change
    create_table :educations do |t|
      t.integer :uni_year_id
      t.integer :semester_id
      t.integer :year
      t.string :university_id
      t.string :faculty_id
      t.integer :course_id
      t.integer :user_id

      t.timestamps
    end
  end
end
