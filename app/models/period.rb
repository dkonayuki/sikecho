class Period < ActiveRecord::Base
  belongs_to :subject
  
  MAX_TIME = 7
  MAX_DAY = 6

end
