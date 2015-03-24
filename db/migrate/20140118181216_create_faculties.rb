class CreateFaculties < ActiveRecord::Migration
  def change
    create_table :faculties do |t|
      t.string :name
      t.string :website
      t.text :info
      t.references :university, index: true

      t.timestamps null: false
    end
  end
end
