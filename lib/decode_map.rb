require 'daud_coder'

#
# Decorates a map-like entity by encoding all the strings (and being recursive on map-like entities)
#
module DecodeMap
  
  def [](a)
    v = super
    if v.instance_of? String
      return DaudCoder.from_daud(v)
    elsif v.kind_of? Numeric
      return v
    elsif v.respond_to?(:[])
      return v.extend(DecodeMap)
    else
      return v
    end
  end
end