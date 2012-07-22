require 'spec_helper'

describe Event do
  
  fixtures :accounts, :events, :accounts_events
  
  describe "on find with account" do
 
    before(:each) do 
      @account = accounts(:pennsic)
    end

    it "Returns nil if the event does not exist" do
      result = Event.find_with_account(100, @account)
      result.should be_nil
    end
    
    it "Returns the event if it exists and is associated with the account" do
      event = events(:pennsic_40)
      result = Event.find_with_account(event.id, @account)
      result.should eq(event)
    end
    
    it "Returns nil if the event exists but is not associated with the account" do
      result = Event.find_with_account(events(:war_practice_2011).id, @account)
      result.should be_nil
    end
  end
  
  describe "on find all for account" do
    
    it "Returns nil if there are no events for that account" do
      account = Account.new(:name => 'test', :password => 'pwd')
      account.save!
      result = Event.find_all_for_account(account)
      result.should be_empty
    end
    
    it "Returns non nil if there are events for that account" do
      account = accounts(:pennsic)
      result = Event.find_all_for_account(account).order("title")
      result.should eq(events(:pennsic_40, :pennsic_39))
    end
  end
  
end
