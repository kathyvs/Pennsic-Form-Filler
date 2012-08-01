require 'daud_coder'

#
# Decorates a map-like entity by encoding all the strings (and being recursive on map-like entities)
#
module DecodeMap
  
  def [](a)
    v = super
    _modify_result(v)
  end
  
  def each
    super do |k, v|
      yield k, _modify_result(v)
    end
  end
  
  private
  
  def _modify_result(v)
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