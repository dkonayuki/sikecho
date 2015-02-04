class CreateUniYears < ActiveRecord::Migration
  def change
    create_table :uni_years do |t|
      t.integer :no
      t.string :name
      t.references :university, index: true

      t.timestamps null: false
    end
  end
end
