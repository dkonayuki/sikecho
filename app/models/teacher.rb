class Teacher < ActiveRecord::Base
  TITLES = [:doctor, :professor]

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
    if last_name_kanji.blank? || first_name_kanji.blank?
      name_en
    else
      "#{last_name_kanji} #{first_name_kanji}"  
    end
  end
  
  def name_en
    "#{first_name} #{last_name}"
  end
  
  def full_name
    I18n.locale == :ja ? name_kanji : name_en
  end
  
  #display image if exists
  def display_profile_image
    if self.picture.present? && self.picture.url(:small).present?
      self.picture.url(:small)
    else
      ActionController::Base.helpers.asset_path('user_profile.png')
    end
  end
  
end
