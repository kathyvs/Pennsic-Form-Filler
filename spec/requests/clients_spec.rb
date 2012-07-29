require 'spec_helper'

describe "Clients" do
  include AuthorizationHandler

  fixtures :accounts, :events
  
  describe "GET /events/1/clients" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      login_as(:clerk)
      get event_clients_path(:event_id => 39)
      response.status.should be(200)
    end
  end
end
