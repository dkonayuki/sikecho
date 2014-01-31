class CreateFacultiesAndSubjectsJoinTable < ActiveRecord::Migration
    def change
      create_table :faculties_subjects do |t|
        t.belongs_to :subject
        t.belongs_to :faculty
      end
    end
end
