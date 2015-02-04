class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references :user, index: true
      t.integer :value
      t.references :votable, polymorphic: true, index: true
    end
  end
end
