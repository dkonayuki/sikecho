module ApplicationHelper
  
  #helper link, add active class when current_page is link_path
  def nav_link(link_text, link_path, html_options = {})
    class_name = current_page?(link_path) ? 'active' : ''
    
    if html_options[:class]
      html_options[:class] += class_name
    else
      html_options[:class] = class_name
    end
    
    if link_text.blank?
      link_to('#', html_options, &block)
    else
      link_to link_text, link_path, html_options
    end
  end
  
  #helper link for broadcast
  def broadcast(channel, &block)
    message = {channel: channel, data: capture(&block), ext: {auth_token: FAYE_TOKEN}}
    uri = URI.parse(faye_server_url)
    Net::HTTP.post_form(uri, message: message.to_json)
  end
  
  #faye server url
  def faye_server_url
    "#{request.protocol}#{request.host}:9292/faye"
  end
  
  #helper link for shallow= true
  def shallow_args(parent, child)
    child.try(:new_record?) ? [parent, child] : child
  end
  
  # get subdomain as current university
  def current_university
    University.find_by_codename(request.subdomain)
  end
  
  def current_admin
    if current_user
      current_user.role.to_sym == :admin ? true : false
    else
      false
    end
  end
  
  # get current language for js
  def current_translations
    @translations ||= I18n.backend.send(:translations)
    @translations[I18n.locale].with_indifferent_access
  end
  
  def disable_nav
    @disable_nav = true
  end
  
  def disable_footer
    @disable_footer = true
  end
  
  def disable_university_select
    @disable_uni_select = true
  end
  
end
