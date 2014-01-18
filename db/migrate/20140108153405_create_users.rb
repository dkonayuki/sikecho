class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :password_digest
      t.string :email
      t.string :nickname
      t.integer :university_id
      t.integer :faculty_id
      t.integer :course_id
      t.string :first_name
      t.string :last_name
      t.string :avatar
      t.date :dob
      t.text :status

      t.timestamps
    end
  end
end
