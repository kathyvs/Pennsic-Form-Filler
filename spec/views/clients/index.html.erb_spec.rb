require 'spec_helper'

describe "clients/index.html.erb" do
  before(:each) do
    assign(:clients, [
      stub_model(Client,
        :society_name => "Society Name",
        :legal_name => "Legal Name",
        :address_1 => "Address 1",
        :address_2 => "Address 2",
        :branch_name => "Branch Name",
        :phone_number => "Phone Number",
        :email => "Email"
      ),
      stub_model(Client,
        :society_name => "Society Name",
        :legal_name => "Legal Name",
        :address_1 => "Address 1",
        :address_2 => "Address 2",
        :branch_name => "Branch Name",
        :phone_number => "Phone Number",
        :email => "Email"
      )
    ])
  end

  it "renders a list of clients" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Society Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Legal Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Address 1".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Address 2".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Branch Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Phone Number".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Email".to_s, :count => 2
  end
end
