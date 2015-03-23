class Teacher < ActiveRecord::Base
  belongs_to :faculty
  belongs_to :university
  has_and_belongs_to_many :subjects

  validates :first_name, presence: true, length: 1..16
  validates :last_name, presence: true, length: 1..16
  
  has_attached_file :picture, styles: {thumbnail: "120x120#", small: "150x150^"}, 
                              #local config
                              url: "/uploads/teachers/:id/picture/:style/:basename.:extension",
                              path: ":rails_root/public/:url" #dont really need path
                              
  validates_attachment_content_type :picture, content_type: ["image/jpg", "image/gif", "image/png", "image/jpeg"]
  
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
