class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :type
      t.string :path
      t.string :name
      t.integer :note_id

      t.timestamps
    end
  end
end
