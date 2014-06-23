class AddAttachmentPictureToSubjects < ActiveRecord::Migration
  def self.up
    change_table :subjects do |t|
      t.attachment :picture
    end
  end

  def self.down
    drop_attached_file :subjects, :picture
  end
end
