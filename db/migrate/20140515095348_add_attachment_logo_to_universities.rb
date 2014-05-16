class AddAttachmentLogoToUniversities < ActiveRecord::Migration
  def self.up
    change_table :universities do |t|
      t.attachment :logo
    end
  end

  def self.down
    drop_attached_file :universities, :logo
  end
end
