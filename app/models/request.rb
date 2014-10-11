class Request < ActiveRecord::Base
  belongs_to :user
  
  has_attached_file :logo, styles: {thumbnail: "60x60#", small: "150x150>"}, 
                            #local config
                            url: "/uploads/requests/:id/logo/:style/:basename.:extension",
                            path: ":rails_root/public/:url" #dont really need path
                            
  validates_attachment_content_type :logo, content_type: ["image/jpg", "image/gif", "image/png", "image/jpeg"]
  validates :name, presence: true
  
  before_validation :strip_blanks
  
  def strip_blanks
    self.name = self.name.strip if !self.name.blank?
    self.website = self.website.strip if !self.website.blank?
  end
                            
end
