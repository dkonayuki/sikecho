class Teacher < ActiveRecord::Base
  belongs_to :faculty
  belongs_to :university
  has_and_belongs_to_many :subjects
  
  def name_kanji
    "#{last_name_kanji} #{first_name_kanji}"  
  end
  
  def name_en
    "#{first_name} #{first_name}"
  end
  
end
