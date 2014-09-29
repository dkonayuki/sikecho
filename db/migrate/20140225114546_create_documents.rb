class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.integer :note_id
      t.string :title

      t.timestamps
    end
  end
end
