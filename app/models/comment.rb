class Comment < ActiveRecord::Base
  validates :content, presence: true, length: 4..150

  belongs_to :user
  belongs_to :commentable, polymorphic: true
end
