class CreateUniversities < ActiveRecord::Migration
  def change
    create_table :universities do |t|
      t.string :name
      t.string :address
      t.string :website

      t.timestamps null: false
    end
  end
end
