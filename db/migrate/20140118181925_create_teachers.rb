class CreateTeachers < ActiveRecord::Migration
  def change
    create_table :teachers do |t|
      t.string :first_name
      t.string :first_name_kana
      t.string :first_name_kanji
      t.string :last_name
      t.string :last_name_kana
      t.string :last_name_kanji
      t.text :info
      t.string :title
      t.references :university, index: true
      t.references :faculty, index: true
      t.string :lab
      t.string :lab_url
      t.string :email

      t.timestamps null: false
    end
  end
end
