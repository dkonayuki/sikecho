module DeviseHelper
  
  #custom error_messages
  def devise_error_messages!
    return '' if resource.errors.empty?
    
    errors = resource.errors.full_messages
    messages = errors.map { |msg| content_tag(:li, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block"> <button type="button"
    class="close" data-dismiss="alert">x</button>
      #{messages}
    </div>
    HTML

    html.html_safe
  end
end