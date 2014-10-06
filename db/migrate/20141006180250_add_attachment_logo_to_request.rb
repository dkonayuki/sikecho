class AddAttachmentLogoToRequest < ActiveRecord::Migration
  def self.up
    change_table :requests do |t|
      t.attachment :logo
    end
  end

  def self.down
    drop_attached_file :requests, :logo
  end
end
