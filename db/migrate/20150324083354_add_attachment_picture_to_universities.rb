class AddAttachmentPictureToUniversities < ActiveRecord::Migration
  def self.up
    change_table :universities do |t|
      t.attachment :picture
    end
  end

  def self.down
    remove_attachment :universities, :picture
  end
end
