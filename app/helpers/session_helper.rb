module SessionHelper
  
  def field_classes(field)
    classes = ['field']
    classes << 'field_with_errors' if (@login.errors.messages.has_key?(field))
    return classes.join(' ')
  end
end
