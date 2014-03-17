class Document < ActiveRecord::Base  
  belongs_to :note  
  has_attached_file :upload, styles: {thumbnail: ["60x60#", :jpg], small: ["150x150>", :jpg]} #force type
                              #local config
                              #url: "/uploads/:id/:style/:basename.:extension",
                              #path: ":rails_root/public/:url" #dont really need path
                              
  validates_attachment_content_type :upload, content_type: ["image/jpg", "image/gif", "image/png", "application/pdf", "image/jpeg"]
  
  include Rails.application.routes.url_helpers
    
  def to_jq_upload
    {
      "id" => self.id,
      "name" => read_attribute(:upload_file_name),
      "size" => read_attribute(:upload_file_size),
      "url" => upload.url(:original),
      "thumbnail_url" => upload.url(:thumbnail),
      "delete_url" => document_path(self),
      "delete_type" => "DELETE" 
    }
  end
  
  def file_type
    File.extname(upload_file_name)
  end
  
end