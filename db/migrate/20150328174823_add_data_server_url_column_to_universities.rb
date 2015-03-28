class AddDataServerUrlColumnToUniversities < ActiveRecord::Migration
  def change
    add_column :universities, :data_server_url, :string
  end
end
