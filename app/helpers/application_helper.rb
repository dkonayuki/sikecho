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
  
  #helper link for shallow= true
  def shallow_args(parent, child)
    child.try(:new_record?) ? [parent, child] : child
  end
  
  # get subdomain as current university
  def current_university
    University.find_by_codename(request.subdomain)
  end
  
end
