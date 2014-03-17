module ApplicationHelper
  
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
  
end
