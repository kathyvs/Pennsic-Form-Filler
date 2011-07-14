require 'spec_helper'

describe "forms/index.html.erb" do
  before(:each) do
    assign(:forms, [
      stub_model(Form,
        :type => "Type",
        :action_type => "Action Type",
        :action_sub_type => "Action Sub Type",
        :herald => "Herald",
        :heralds_email => "Heralds Email",
        :client_id => 1
      ),
      stub_model(Form,
        :type => "Type",
        :action_type => "Action Type",
        :action_sub_type => "Action Sub Type",
        :herald => "Herald",
        :heralds_email => "Heralds Email",
        :client_id => 1
      )
    ])
  end

  it "renders a list of forms" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Type".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Action Type".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Action Sub Type".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Herald".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Heralds Email".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
