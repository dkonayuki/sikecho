class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.text :title
      t.text :content
      t.integer :user_id
      t.integer :view

      t.timestamps
    end
  end
end
