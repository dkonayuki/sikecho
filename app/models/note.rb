class Note < ActiveRecord::Base
  belongs_to :user 
  has_and_belongs_to_many :subjects
  has_many :documents
end
