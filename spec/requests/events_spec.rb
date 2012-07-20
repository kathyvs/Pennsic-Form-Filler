require 'spec_helper'

describe "Events" do
  include AuthorizationHandler
  describe "GET /events" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      login_as :admin
      get events_path
      response.status.should be(200)
    end
  end
end
