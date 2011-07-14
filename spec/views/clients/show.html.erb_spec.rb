require 'spec_helper'

describe "clients/show.html.erb" do
  before(:each) do
    @client = assign(:client, stub_model(Client,
      :society_name => "Society Name",
      :legal_name => "Legal Name",
      :address_1 => "Address 1",
      :address_2 => "Address 2",
      :branch_name => "Branch Name",
      :phone_number => "Phone Number",
      :email => "Email"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Society Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Legal Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Address 1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Address 2/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Branch Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Phone Number/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Email/)
  end
end
