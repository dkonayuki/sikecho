class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.references :user, index: true
      t.integer :count, default: 1
      t.string :name
      t.string :address
      t.string :website

      t.timestamps null: false
    end
  end
end
