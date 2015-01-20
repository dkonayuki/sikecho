class Faculty < ActiveRecord::Base
  belongs_to :university
  validates :university, presence: true
  validates :name, presence: true, length: 1..16

  has_many :teachers
  has_many :courses, dependent: :destroy
  has_many :educations
end