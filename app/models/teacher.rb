class Teacher < ActiveRecord::Base
  belongs_to :faculty
  belongs_to :university
  has_and_belongs_to_many :subjects
end
