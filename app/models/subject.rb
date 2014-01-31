class Subject < ActiveRecord::Base
  has_and_belongs_to_many :faculties
  has_and_belongs_to_many :notes
end
