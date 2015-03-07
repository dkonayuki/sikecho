class Comment < ActiveRecord::Base
  #for custom activity
  include PublicActivity::Common

  validates :content, presence: true, length: 4..150

  belongs_to :user
  belongs_to :commentable, polymorphic: true
end
