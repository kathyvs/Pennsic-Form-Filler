require 'spec_helper'

describe Event do
  fixtures(:accounts, :events)

  describe "find with account" do
 
    before(:each) do 
      @account = accounts(:pennsic)
    end
    it "Returns nil if the event does not exist" do
      result = Event.find_with_account(100, @account)
      result.should be_nil
    end
    it "Returns the event if it exists and belongs to the account" do
      event = events(:pennsic_40)
      result = Event.find_with_account(event.id, @account)
      result.should eq(event)
    end
    it "Returns nil if the event exists but belongs to a different account" do
      result = Event.find_with_account(events(:war_practice_2011).id, @account)
      result.should be_nil
    end
  end
end
