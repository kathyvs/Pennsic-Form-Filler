require "spec_helper"

describe ClientsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/events/1/clients" }.should route_to(
          :controller => "clients", :action => "index", :event_id => "1")
    end

    it "recognizes and generates #new" do
      { :get => "/events/1/clients/new" }.should route_to(
          :controller => "clients", :action => "new", :event_id => "1")
    end

    it "recognizes and generates #show" do
      { :get => "/events/3/clients/1" }.should route_to(
          :controller => "clients", :action => "show", :id => "1", :event_id => "3")
    end

    it "recognizes and generates #edit" do
      { :get => "/events/3/clients/1/edit" }.should route_to(
          :controller => "clients", :action => "edit", :id => "1", :event_id => "3")
    end

    it "recognizes and generates #create" do
      { :post => "/events/4/clients" }.should route_to(
          :controller => "clients", :action => "create", :event_id => "4")
    end

    it "recognizes and generates #update" do
      { :put => "/events/4/clients/1" }.should route_to(
          :controller => "clients", :action => "update", :id => "1", :event_id => "4")
    end

  end
end
