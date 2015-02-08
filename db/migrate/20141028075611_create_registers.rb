class CreateRegisters < ActiveRecord::Migration
  def change
    create_table :registers do |t|
      t.belongs_to :education, index: true
      t.belongs_to :subject, index: true
      t.datetime :register_time
    end
  end
end
