class UpdateUnreadForPublicActivitySupport < ActiveRecord::Migration
  def change
    change_column :read_marks, :readable_type, :text
  end
end
