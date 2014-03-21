class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
      t.string :name
      t.text :description
      t.integer :credit
      t.string :place
      t.integer :semester_id
      t.integer :uni_year_id
      t.integer :university_id
      t.integer :number_of_outlines
      t.integer :year

      t.timestamps
    end
  end
end
