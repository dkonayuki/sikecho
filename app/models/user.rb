class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  has_secure_password
  
  belongs_to :university 
  belongs_to :faculty 
  
  has_and_belongs_to_many :subjects
  has_many :notes, dependent: :destroy
end
