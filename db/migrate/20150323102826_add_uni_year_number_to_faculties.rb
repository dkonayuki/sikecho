class AddUniYearNumberToFaculties < ActiveRecord::Migration
  def change
    add_column :faculties, :uni_year_number, :integer
  end
end
