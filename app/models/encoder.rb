require 'daud_coder'
module Encoder
  def initialize(attributes = nil)
    attributes = attributes.inject({}) { |memo, (k, v)| memo[k] = DaudCoder.from_daud v}
    super
  end
end