class CreateEducations < ActiveRecord::Migration
  def change
    create_table :educations do |t|
      t.references :uni_year, index: true
      t.references :semester, index: true
      t.references :university, index: true
      t.references :faculty, index: true
      t.references :course, index: true
      t.references :user, index: true

      t.integer :year
      t.integer :current_user_id #need for has_one and has_many on the same model

      t.timestamps null: false
    end
  end
end
