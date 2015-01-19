class AddEnglishNameColumnToUniversities < ActiveRecord::Migration
  def change
    add_column :universities, :en_name, :string
  end
end
