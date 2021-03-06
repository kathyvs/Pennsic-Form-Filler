require 'spec_helper'
require 'set'

# Specs in this file have access to a helper object that includes
# the EventsHelper. For example:
#
# describe EventsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe EventsHelper do
  
  def events_from(titles)
    index = 0
    titles.map do |t| 
      index += 1
      e = Event.new(:title => t)
      e.id = index
      e
    end
  end
  
  describe "current_event_options" do
    before :each do 
      titles = ["A", "B", "C", "D", "E"]
      @events = events_from titles 
    end

    it "is a list of options" do
      result = helper.current_event_options(@events)
      result.should start_with("<option")
      result.should end_with("</option>")
    end

    it "collects all events with id and title " do
      result = helper.current_event_options(@events)
      @events.each do |e|
        result.should include(e.title)
        result.should include(e.id.to_s)
      end
    end
    
    it "includes --No Current Event-- as well" do
      result = helper.current_event_options(@events)
      result.should include('--No Current Event--')
    end
    
    it "includes the current event as selected" do
      e = @events[1]
      e.is_current = true
      result = helper.current_event_options(@events)
      result.should include("selected=\"selected\">#{e.title}")
    end
    
  end
  
  describe "event accounts" do
    before :each do 
      titles = ["A", "B", "C", "D", "E", "F"]
      account_map = {:u1 => [], :u2 => ["A", "B", "C"], :u3 => ["B", "D"], :u4 => "E"}
      @events = events_from titles
      index = 1
      @accounts = []
      account_map.each_pair do |name, events|
        account = Account.new(:id => index, :name => name.to_s)
        account.events << events.map {|t| @events.find {|e| e.title == t}}
        @accounts << account
      end 
    end
    
    it "splits accounts by event" do
      @events.each do |event|
        split_values = helper.split_accounts(event, @accounts)
        members = split_values[:members]
        nonmembers = split_values[:nonmembers]
        actual = (members + nonmembers).sort_by(&:name)
        expected = @accounts.sort_by(&:name)
        actual.should eq(expected)
        members.each do |member|
          member.events.should include(event)
        end
        nonmembers.each do |nonmember|
          nonmember.events.should_not include(event)
        end
      end
    end
  end
  
end
