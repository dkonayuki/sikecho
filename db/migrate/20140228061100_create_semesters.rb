class CreateSemesters < ActiveRecord::Migration
  def change
    create_table :semesters do |t|
      t.integer :no
      t.string :name
      t.integer :uni_year_id

      t.timestamps
    end
  end
end