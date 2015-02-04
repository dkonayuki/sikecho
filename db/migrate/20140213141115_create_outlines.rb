class CreateOutlines < ActiveRecord::Migration
  def change
    create_table :outlines do |t|
      t.integer :no
      t.date :date
      t.text :content
      t.references :subject, index: true

      t.timestamps null: false
    end
  end
end
