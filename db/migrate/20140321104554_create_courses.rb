class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.text :info
      t.references :faculty, index: true

      t.timestamps null: false
    end
  end
end
