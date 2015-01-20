class Teacher < ActiveRecord::Base
  belongs_to :faculty
  belongs_to :university
  has_and_belongs_to_many :subjects

  validates :first_name, presence: true, length: 1..16
  validates :last_name, presence: true, length: 1..16
  
  def name_kanji
    "#{last_name_kanji} #{first_name_kanji}"  
  end
  
  def name_en
    "#{first_name} #{last_name}"
  end
  
  def full_name
    I18n.locale == :ja ? name_kanji : name_en
  end
  
end
