module ApplicationHelper
  def save_file(user, filename, filedata)
    userpath = Rails.root.join("public","uploads",user.username)
    FileUtils.mkdir_p(userpath)
    path = File.join(userpath, filename)
    File.open(path,"wb") do |f|
      f.write(filedata.read)
    end
    path
  end
  
  def delete_file(path)
    File.delete(path)
  end
  
  def day_names(day)
    %w(月曜日 火曜日 水曜日 木曜日 金曜日 土曜日)[day - 1]
  end
  
  def day_names_short(day)
    %w(月 火 水 木 金 土)[day - 1]
  end
  
  def time_names(time)
    %w(一時限 二時限 三時限 四時限 五時限 六時限 七時限 八時限)[time - 1]
  end
  
  def time_names_short(time)
    %w(1 2 3 4 5 6 7 8)[time - 1]
  end
  
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
