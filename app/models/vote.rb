class Vote < ActiveRecord::Base
  # vote is used in view as rating/like/dislike
  # basically the same thing
  
  belongs_to :user
  
  #vote can belong to any model that is votable
  belongs_to :votable, polymorphic: true
end