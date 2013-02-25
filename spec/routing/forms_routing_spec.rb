require "spec_helper"

describe FormsController do
  describe "routing" do

    def expected_route(event_id, client_id, extras) 
      result = extras.clone
      result[:event_id] = event_id.to_s
      result[:client_id] = client_id.to_s
      result[:controller] = "forms"
      return result
    end
    
    it "recognizes and generates #index" do
      { :get => "/events/1/clients/2/forms" }.should \
        route_to(expected_route 1, 2, :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/events/2/clients/3/forms/new" }.should \
         route_to(expected_route 2, 3, :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/events/3/clients/4/forms/1" }.should \
         route_to(expected_route 3, 4, :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/events/2/clients/10/forms/1/edit" }.should \
        route_to(expected_route 2, 10, :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/events/3/clients/1/forms" }.should \
         route_to(expected_route 3, 1, :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/events/6/clients/5/forms/3" }.should \
        route_to(expected_route 6, 5, :action => "update", :id => "3")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/events/8/clients/1/forms/2" }.should \
        route_to(expected_route 8, 1, :action => "destroy", :id => "2")
    end

  end
end
