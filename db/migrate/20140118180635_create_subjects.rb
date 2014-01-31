class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
      t.string :name
      t.text :description
      t.string :subject_code
      t.integer :credit

      t.timestamps
    end
  end
end
