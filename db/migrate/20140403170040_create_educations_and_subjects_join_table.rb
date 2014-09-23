class CreateEducationsAndSubjectsJoinTable < ActiveRecord::Migration
  def change
    create_table :educations_subjects do |t|
      t.belongs_to :education
      t.belongs_to :subject
    end
  end
end
