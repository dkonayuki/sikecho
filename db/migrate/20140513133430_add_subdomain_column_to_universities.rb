class AddSubdomainColumnToUniversities < ActiveRecord::Migration
  def change
    add_column :universities, :codename, :string
  end
end
