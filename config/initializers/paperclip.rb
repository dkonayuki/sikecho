#amazon s3 config
Paperclip::Attachment.default_options[:url] = ':s3_domain_url'
Paperclip::Attachment.default_options[:path] = '/:class/:attachment/:id_partition/:style/:filename'
Paperclip::Attachment.default_options[:s3_credentials] = { 
  bucket: 'shikechou',
  access_key_id: 'AKIAILMU7T2SW3RLW3BQ',
  secret_access_key: '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'
  }
Paperclip::Attachment.default_options[:storage] = :s3
#setup with environment variables
#Paperclip::Attachment.default_options[:s3_credentials] = 
#  { :bucket => ENV['AWS_BUCKET'],
#    :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
#    :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'] }