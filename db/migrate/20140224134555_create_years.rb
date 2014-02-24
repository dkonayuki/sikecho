class CreateYears < ActiveRecord::Migration
  def change
    create_table :years do |t|
      t.integer :no
      t.string :name
      t.integer :university_id

      t.timestamps
    end
  end
end
