class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.text :title
      t.text :content
      t.text :image_path
      t.text :pdf_path
      t.integer :user_id
      t.integer :subject_id

      t.timestamps
    end
  end
end
