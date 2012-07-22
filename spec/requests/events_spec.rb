require 'spec_helper'

describe "Events" do
  include AuthorizationHandler
  extend FixtureHelper
  
  fixture_list account_fixtures
  
  describe "setup" do
    it "admin sets up events" do
      login_as :admin
      get "/events"
      get "/events/new"
    end
    
    it "admin sets current event" do
      login_as :admin
      get "/events"
      assert_select "label", "Current Event"
      put "/events/current", :event_id => 39
    end
  end
end
