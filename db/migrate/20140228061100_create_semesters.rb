class CreateSemesters < ActiveRecord::Migration
  def change
    create_table :semesters do |t|
      t.integer :no
      t.string :name
      t.references :uni_year, index: true

      t.timestamps null: false
    end
  end
end
