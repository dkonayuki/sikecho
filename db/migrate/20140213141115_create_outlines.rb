class CreateOutlines < ActiveRecord::Migration
  def change
    create_table :outlines do |t|
      t.integer :number
      t.date :date
      t.text :content
      t.integer :subject_id

      t.timestamps
    end
  end
end
