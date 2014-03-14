class Period < ActiveRecord::Base
  belongs_to :subject
  
  def self.MAX_TIME
    7
  end
  
  def self.MAX_DAY
    6
  end
end
