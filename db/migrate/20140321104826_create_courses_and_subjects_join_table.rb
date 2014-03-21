class CreateCoursesAndSubjectsJoinTable < ActiveRecord::Migration
  def change
    create_table :courses_subjects do |t|
      t.belongs_to :subject
      t.belongs_to :course
    end
  end
end
