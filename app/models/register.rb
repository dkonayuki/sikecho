class Register < ActiveRecord::Base
  belongs_to :subject
  belongs_to :education
end