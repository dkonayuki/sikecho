class CreatePeriods < ActiveRecord::Migration
  def change
    create_table :periods do |t|
      t.integer :day
      t.integer :time
      t.integer :subject_id

      t.timestamps
    end
  end
end
