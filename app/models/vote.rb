class Vote < ActiveRecord::Base
  belongs_to :user
  
  #vote can belong to any model that is votable
  belongs_to :votable, polymorphic: true
end