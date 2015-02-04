class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
      t.string :name
      t.text :description
      t.integer :credit
      t.string :place
      t.references :semester, index: true
      t.references :uni_year, index: true
      t.references :course, index: true
      t.integer :year
      t.integer :view_count, default: 0
      t.integer :notes_count, default: 0

      t.timestamps null: false
    end
  end
end
