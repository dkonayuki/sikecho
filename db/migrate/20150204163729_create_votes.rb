class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references :user, index: true
      t.integer :value, default: 0
      t.references :votable, polymorphic: true, index: true
      t.timestamps
    end
  end
end
