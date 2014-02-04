class Faculty < ActiveRecord::Base
  belongs_to :university
  has_many :teachers
  has_many :users
  has_and_belongs_to_many :subjects
end
