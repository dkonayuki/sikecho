class CreateFaculties < ActiveRecord::Migration
  def change
    create_table :faculties do |t|
      t.string :name
      t.string :website
      t.integer :university_id

      t.timestamps
    end
  end
end
