require 'spec_helper'

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
  
  describe "current_event_options" do
    before :each do 
      titles = ["A", "B", "C", "D", "E"]
      index = 0
      @events = titles.map do |t| 
        index += 1
        e = Event.new(:title => t)
        e.id = index
        e
      end
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
  
end
