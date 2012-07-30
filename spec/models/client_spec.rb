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
  
  describe "get_counts" do
    # Add a simple scope for testing
    class Client
      scope :women, lambda { |event_id| where(:gender => 'Female', :event_id => event_id)}
    end

    before(:each) do
      @event = Event.new(:title => 'Test')
      @event.save!
    end
    
    def get_counts(scope)
      Client.get_counts(scope, @event)
    end
    
    def create_clients(sca_names, legal_names = nil, options = {})
      legal_names ||= sca_names.map {|n| "Name for #{n}"}
      sca_names.each_with_index do |sname, index|
        client = Client.new(:society_name => sname, :legal_name => legal_names[index],
           :address_1 => 'ignored', :address_2 => 'ignored', :kingdom => 'test', 
           :event_id => @event.id)
        options.each_pair do |prop, values|
          client.send("#{prop}=", values[index])
        end
        client.save!
      end
    end

    it "returns an empty hash when there are no client" do
      get_counts(:every).should be_empty
    end
    
    it "returns counts on initial society_names" do
      sca_names = ["Abd", "Alaric", "Cecelia", "Robert"]
      create_clients(sca_names)
      get_counts(:every).should eq({'A' => 2, 'C' => 1, 'R' => 1})
    end
    
    it "uses legal names if society names are missing" do
      sca_names = ["Abd", "Alaric", nil, "Robert"]
      legal_names = ["John Smith", "Robert", "Jane", "William"]
      create_clients(sca_names, legal_names)
      get_counts(:every).should eq({'A' => 2, 'J' => 1, 'R' => 1})
    end
    
    it "uses scope" do
      sca_names = ["One", "Two", "Three", "Four"]
      genders = ["Female", "Male", "Male", "Female"]
      create_clients(sca_names, nil, :gender => genders)
      get_counts(:women).should eq({'O' => 1, 'F' => 1})
    end
    
  end
  
  describe "validation" do
    before(:each) do
      @event = events(:pennsic_39)
      @client = Client.new(
          :legal_name => 'John Smith',
          :address_1 => '100 Main St',
          :kingdom => 'East')
    end
    
    it "defaults are valid" do
      if (!@client.valid?)
        fail("Unexpected errors: #{@client.errors}")
      end
      @client.should be_valid
    end
    
    [:legal_name, :address_1, :kingdom].each do |item|
      it "requires #{item}" do
        @client.send("#{item}=", nil)
        @client.should have(1).error_on(item)
      end
    end
  end
  
  describe "display name" do
    it "Returns SCA name if it exists" do
      result = clients(:anne)
      result.display_name.should eq(result.society_name)
    end
    
    it "Returns the legal name if SCA name does not exist" do
      result = clients(:no_name)
      result.display_name.should eq("<#{result.legal_name}>")
    end
  end
end
