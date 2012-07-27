require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe ClientsController do

  include AuthHelper
  extend FixtureHelper
  fixture_list account_fixtures, event_fixtures, :clients

  render_views
    
  describe "GET index" do
    before :each do
      @event = events(:pennsic_40)
    end
    
    def get_index(params = {})
      params[:event_id] = @event.id
      get :index, params
    end
    
    it "requires authentication" do
      verify_needs_authorization do 
        get_index
      end
    end
    
    describe "when can view all clients" do
      
      before :each do 
        account = login_with_rights(:view_all_clients)
        account.events << @event
        account.save! 
      end
      
      describe "with no params" do
        
        it "assigns clients to @clients" do
          get_index
          assigns(:clients).should include(*Client.all)
        end
        
        it "assigns scope to :every" do
          get_index
          assigns(:scope).should eq(:every)
        end
        
        it "assigns counts based on scope" do
          counts = {'A' => 3}
          Client.stub("get_counts").with(:every, @event) { counts}
          get_index
          assigns(:counts).should eq(counts)
        end

      end
    end
    it "returns all clients for the given event"
  end

  describe "GET show" do
    it "assigns the requested client as @client"
  end

  describe "GET new" do
    it "assigns a new client as @client"
  end

  describe "GET edit" do
    it "assigns the requested client as @client" 
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created client as @client"

      it "redirects to the created client"
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved client as @client"

      it "re-renders the 'new' template"
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested client"

      it "assigns the requested client as @client"

      it "redirects to the client" 
    end

    describe "with invalid params" do
      it "assigns the client as @client"

      it "re-renders the 'edit' template"
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested client"

    it "redirects to the clients list"
  end

end
