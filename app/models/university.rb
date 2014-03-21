class University < ActiveRecord::Base
  has_many :faculties
  has_many :teachers
  has_many :uni_years
  has_many :users
  has_many :subjects
end
