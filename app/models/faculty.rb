class Faculty < ActiveRecord::Base
  belongs_to :university
  has_and_belongs_to_many :subjects
end
