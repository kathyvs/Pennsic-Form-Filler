require 'spec_helper'

describe "forms/show.html.erb" do
  before(:each) do
    @form = assign(:form, stub_model(Form,
      :type => "Type",
      :action_type => "Action Type",
      :action_sub_type => "Action Sub Type",
      :herald => "Herald",
      :heralds_email => "Heralds Email",
      :client_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Type/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Action Type/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Action Sub Type/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Herald/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Heralds Email/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
