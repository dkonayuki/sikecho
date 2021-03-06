class Document < ActiveRecord::Base  
  
  belongs_to :note
  has_many :comments, as: :commentable

  has_attached_file :upload, styles: {pdf_thumbnail: ["", :jpg], thumbnail: ["60x60#", :jpg], small: ["150x150^", :jpg]}, #force type
                              convert_options: {
                                all: '-background white -flatten +matte'
                              },
                              #local config
                              url: "/uploads/documents/:id/:style/:basename.:extension",
                              path: ":rails_root/public/:url" #dont really need path
                              
  validates_attachment_content_type :upload, content_type: ["image/jpg", "image/gif", "image/png", "application/pdf", "image/jpeg"]
  
  include Rails.application.routes.url_helpers
    
  def to_jq_upload
    if file_type == '.pdf'
    {
      "id" => id,
      "title" => title,
      "name" => read_attribute(:upload_file_name),
      "size" => read_attribute(:upload_file_size),
      "url" => upload.url(:original),
      "thumbnail_url" => upload.url(:pdf_thumbnail),
      "delete_url" => document_path(self, locale: I18n.locale),
      "delete_type" => "DELETE" 
    }
    else
    {
      "id" => id,
      "title" => title,
      "name" => read_attribute(:upload_file_name),
      "size" => read_attribute(:upload_file_size),
      "url" => upload.url(:original),
      "thumbnail_url" => upload.url(:thumbnail),
      "delete_url" => document_path(self, locale: I18n.locale),
      "delete_type" => "DELETE" 
    }
    end
  end
  
  def file_type
    File.extname(upload_file_name)
  end
  
end