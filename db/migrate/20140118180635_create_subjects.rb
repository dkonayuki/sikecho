class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
      t.string :name
      t.text :description
      t.integer :credit
      t.integer :time
      t.string :time_name
      t.integer :day
      t.string :day_name
      t.string :place
      t.integer :semester
      t.integer :number_of_outlines

      t.timestamps
    end
  end
end
