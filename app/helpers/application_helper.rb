module ApplicationHelper
  
  #helper link when add more field dynamically
  def link_to_add_fields(name = nil, f, association, html_options, &block)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do | builder |
      render(association.to_s.singularize + '_fields', f: builder)
    end 
    html_options[:class] += ' add_fields'
    html_options[:data] = {id: id, fields: fields.gsub('\n', '')}
    if name.blank?
      link_to('#', html_options, &block)
    else
      link_to(name, '#', html_options)      
    end
  end
  
  #helper link, add active class when current_page is link_path
  def nav_link(link_text, link_path, html_options = {})
    class_name = current_page?(link_path) ? 'active' : ''
    
    if html_options[:class]
      html_options[:class] += class_name
    else
      html_options[:class] = class_name
    end
    
    link_to link_text, link_path, html_options
  end
  
  #helper link for shallow= true
  def shallow_args(parent, child)
    child.try(:new_record?) ? [parent, child] : child
  end
end
