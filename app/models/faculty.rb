class Faculty < ActiveRecord::Base
  belongs_to :university
  
  #dont need to validate university_id because new faculty will be linked to current_university
  validates :university, presence: true
  validates :name, presence: true, length: 1..16

  has_many :teachers
  has_many :courses, dependent: :destroy
  has_many :educations
  
  def uni_year_number_enum
    1..UniYear::MAX_NO
  end
  
end