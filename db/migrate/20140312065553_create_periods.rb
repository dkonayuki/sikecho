class CreatePeriods < ActiveRecord::Migration
  def change
    create_table :periods do |t|
      t.integer :day
      t.integer :time
      t.references :subject, index: true

      t.timestamps null: false
    end
  end
end
