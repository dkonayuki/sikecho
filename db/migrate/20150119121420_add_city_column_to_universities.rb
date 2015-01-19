class AddCityColumnToUniversities < ActiveRecord::Migration
  def change
    add_column :universities, :city, :string
  end
end
