class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.integer :user_id
      t.integer :count, default: 1
      t.string :name
      t.string :address
      t.string :website

      t.timestamps
    end
  end
end
