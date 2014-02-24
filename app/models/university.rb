class University < ActiveRecord::Base
  has_many :faculties
  has_many :teachers
  has_many :years
end
