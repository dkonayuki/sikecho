require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'net/http'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Shikechou
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    
    # change default locale to ja
    config.i18n.default_locale = :ja
    config.i18n.available_locales = [:ja, :en]
    
    config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)
    config.assets.enabled = true
    config.assets.debug = true

    #add asset path for favicon
    config.assets.paths << "#{Rails.root}/app/assets/images/favicon"
    #config.quiet_assets = true
    
    #custom error field display
    config.action_view.field_error_proc = Proc.new do |html_tag, instance|
      class_attr_index = html_tag.index 'class="'
    
      if class_attr_index
        html_tag.insert class_attr_index+7, 'form-error '
      else
        html_tag.insert html_tag.index('>'), ' class="form-error"'
      end
    end
  end
end
