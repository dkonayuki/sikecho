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

      t.timestamps
    end
  end
end
