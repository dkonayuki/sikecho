class Favorite < ActiveRecord::Base
  # favorite is equivalent to star/starred
  # basically the same thing
  
  # to use @user.favorites.notes
  scope :notes, -> { where(favoritable_type: 'Note') }

  belongs_to :user
  
  #favorite can belong to any model that is favoritable
  belongs_to :favoritable, polymorphic: true
  
end
