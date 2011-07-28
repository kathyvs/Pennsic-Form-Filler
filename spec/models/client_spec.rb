require 'spec_helper'

describe Client do
  fixtures(:events, :clients)
  describe "find with event" do
 
    before(:each) do 
      @event = events(:pennsic_39)
    end
    it "Returns nil if the client does not exist" do
      result = Client.find_with_event(100, @account)
      result.should be_nil
    end
    it "Returns the client if it exists and belongs to the event" do
      client = clients(:anne)
      result = Client.find_with_event(client.id, @event)
      result.should eq(client)
    end
    it "Returns nil if the client exists but belongs to a different event" do
      result = Client.find_with_event(clients(:william).id, @event)
      result.should be_nil
    end
  end
end
