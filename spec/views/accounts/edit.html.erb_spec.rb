require 'spec_helper'

describe "accounts/edit.html.erb" do
  before(:each) do
    @account = assign(:account, stub_model(Account,
      :name => "MyString",
      :password => "MyString"
    ))
  end

  it "renders the edit account form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => accounts_path(@account), :method => "post" do
      assert_select "input#account_name", :name => "account[name]"
      assert_select "input#account_password", :name => "account[password]"
    end
  end
end
