class Period < ActiveRecord::Base
  belongs_to :user
  belongs_to :subject
  belongs_to :falcuty
end
