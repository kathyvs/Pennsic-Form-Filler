require 'spec_helper'

describe "forms/edit.html.erb" do
  before(:each) do
    @form = assign(:form, stub_model(Form,
      :type => "MyString",
      :action_type => "MyString",
      :action_sub_type => "MyString",
      :herald => "MyString",
      :heralds_email => "MyString",
      :client_id => 1
    ))
  end

  it "renders the edit form form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => forms_path(@form), :method => "post" do
      assert_select "input#form_type", :name => "form[type]"
      assert_select "input#form_action_type", :name => "form[action_type]"
      assert_select "input#form_action_sub_type", :name => "form[action_sub_type]"
      assert_select "input#form_herald", :name => "form[herald]"
      assert_select "input#form_heralds_email", :name => "form[heralds_email]"
      assert_select "input#form_client_id", :name => "form[client_id]"
    end
  end
end
