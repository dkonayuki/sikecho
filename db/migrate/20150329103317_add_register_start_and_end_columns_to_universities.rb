class AddRegisterStartAndEndColumnsToUniversities < ActiveRecord::Migration
  def change
    add_column :universities, :register_start, :date
    add_column :universities, :register_end, :date
  end
end
