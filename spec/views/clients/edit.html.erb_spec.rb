require 'spec_helper'

describe "clients/edit.html.erb" do
  before(:each) do
    @client = assign(:client, stub_model(Client,
      :society_name => "MyString",
      :legal_name => "MyString",
      :address_1 => "MyString",
      :address_2 => "MyString",
      :branch_name => "MyString",
      :phone_number => "MyString",
      :email => "MyString"
    ))
  end

  it "renders the edit client form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => clients_path(@client), :method => "post" do
      assert_select "input#client_society_name", :name => "client[society_name]"
      assert_select "input#client_legal_name", :name => "client[legal_name]"
      assert_select "input#client_address_1", :name => "client[address_1]"
      assert_select "input#client_address_2", :name => "client[address_2]"
      assert_select "input#client_branch_name", :name => "client[branch_name]"
      assert_select "input#client_phone_number", :name => "client[phone_number]"
      assert_select "input#client_email", :name => "client[email]"
    end
  end
end
