class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.integer :note_id

      t.timestamps
    end
  end
end
