class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.text :title
      t.text :content
      t.references :user, index: true # index: true will be equivalent to add_index
      t.integer :view_count, default: 0

      t.timestamps null: false
    end
  end
end
