class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :password_digest
      t.string :email
      t.string :nickname
      t.string :university
      t.string :faculty
      t.string :course
      t.string :nickname
      t.string :first_name
      t.string :last_name
      t.string :avatar
      t.string :dob
      t.string :status

      t.timestamps
    end
  end
end
