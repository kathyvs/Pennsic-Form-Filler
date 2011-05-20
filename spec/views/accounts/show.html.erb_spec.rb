require 'spec_helper'

describe "accounts/show.html.erb" do
  before(:each) do
    @account = assign(:account, stub_model(Account,
      :name => "Name",
      :password => "Password"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Password/)
  end
end
