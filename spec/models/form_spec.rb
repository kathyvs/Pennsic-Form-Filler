require 'spec_helper'

describe Form do

  Form.types.select do |type, cls|
    it "creates a form of class #{cls} for type #{type}" do
      form = Form.create({:type => type})
      form.should be_a_kind_of(cls)
    end

    it "does not require that #{type} be a symbol" do
      form = Form.create({:type => type.to_s})
      form.should be_a_kind_of(cls)
    end

    it "also creates the correct form from #{cls}" do
      form = Form.create(:type => cls.to_s)
      form.should be_a_kind_of(cls)
    end

  end

  it "sets the other parameters on the form" do
    type = Form.types.keys.first
    params = {:client_id => 3, :herald => 'Test Herald', :type => type}
    form = Form.create(params)
    form.client_id.should eq(3)
    form.herald.should eq('Test Herald')
  end

  it "returns null for an unknown type" do
    bad_form = Form.create({:type => 'xxx'})
    bad_form.should be_nil
  end

end
