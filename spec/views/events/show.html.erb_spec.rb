require 'spec_helper'

describe "events/show.html.erb" do
  before(:each) do
    @event = assign(:event, stub_model(Event,
      :title => "Title",
      :account => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
  end
end
