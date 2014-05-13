class AddAttachmentPictureToUniversities < ActiveRecord::Migration
  def self.up
    change_table :universities do |t|
      t.attachment :picture
    end
  end

  def self.down
    drop_attached_file :universities, :picture
  end
end
