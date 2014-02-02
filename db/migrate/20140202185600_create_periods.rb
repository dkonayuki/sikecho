class CreatePeriods < ActiveRecord::Migration
  def change
    create_table :periods do |t|
      t.integer :time
      t.string :time_name
      t.integer :day
      t.string :day_name
      t.integer :subject_id
      t.integer :user_id

      t.timestamps
    end
  end
end
