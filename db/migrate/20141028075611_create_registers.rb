class CreateRegisters < ActiveRecord::Migration
  def change
    create_table :registers do |t|
      t.belongs_to :education
      t.belongs_to :subject
      t.datetime :created_at
    end
  end
end
