require 'spec_helper'

describe "Clients" do
  
  fixtures :accounts, :events
  
  describe "GET /events/1/clients" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      login(:pennsic)
      get clients_path
      response.status.should be(200)
    end
  end
end
