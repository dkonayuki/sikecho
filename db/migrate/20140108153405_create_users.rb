class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password_digest
      t.string :email
      t.string :nickname
      t.integer :university_id
      t.integer :faculty_id
      t.integer :course_id
      t.string :first_name
      t.string :first_name_kana
      t.string :first_name_kanji
      t.string :last_name
      t.string :last_name_kana
      t.string :last_name_kanji
      t.string :avatar
      t.date :dob
      t.text :status

      t.timestamps
    end
  end
end
