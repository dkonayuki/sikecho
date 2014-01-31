class CreateTeachers < ActiveRecord::Migration
  def change
    create_table :teachers do |t|
      t.string :first_name
      t.string :first_name_kana
      t.string :first_name_kanji
      t.string :last_name
      t.string :last_name_kana
      t.string :last_name_kanji
      t.text :role
      t.integer :university_id
      t.integer :faculty_id

      t.timestamps
    end
  end
end
