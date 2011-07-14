require 'spec_helper'

describe Form do

  Form.types.select do |type, cls|
    it "creates a form of class #{cls} for type #{type}" do
      form = Form.new_with_type(type)
      form.should be_a_kind_of(cls)
    end
  end

  it "returns null for an unknown type" do
     bad_form = Form.new_with_type('xxx')
     bad_form.should be_nil
  end
end
