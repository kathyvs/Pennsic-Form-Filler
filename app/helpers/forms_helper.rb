module FormsHelper

  def options_for_types(types, selected = nil)
     options = types.select do |key, value|
       [key, value.display]
     end
     options_for_select(options, selected)
  end
end
