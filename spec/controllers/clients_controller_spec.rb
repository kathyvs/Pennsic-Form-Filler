require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe ClientsController do

  include AuthHelper
  extend FixtureHelper
  fixture_list account_fixtures, event_fixtures, :clients

  render_views
  
  def login_with_rights(*rights)
    login_with_rights_for_event(@event, *rights)
  end
  
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
      end
      
      def build_clients(names) 
        ids = names.map do |name|
          c = Client.new(:legal_name => name, :event_id => @event.id,
             :address_1 => 'ignored', :kingdom => 'Middle')
          c.save!
          c.id
        end
        return Client.where('id in (?)', ids)
      end
      
      describe "with no params" do
        
        it "assigns clients to @clients" do
          get_index
          assigns(:clients).should include(*Client.where(:event_id => @event))
        end
        
        it "assigns scope to :every" do
          get_index
          assigns(:scope).should eq(:every)
        end
        
        it "assigns counts" do
          get_index
          assigns(:counts).should_not be_nil
        end
        
        it "assigns link_params to have scope" do
          get_index
          assigns(:link_params)[:scope].should eq(:every)
        end

        it "limits size to #{ClientsController::MAX_SIZE}" do
          names = (1..75).map {|i| "John #{i}"}
          build_clients(names)
          get_index
          assigns(:clients).size.should eq(ClientsController::MAX_SIZE)
        end

        it "assigns link_params to have limit" do
          get_index
          assigns(:link_params)[:limit].should eq(ClientsController::MAX_SIZE)
        end
        
        it "assigns count to the actual count total" do
          names = (1..75).map {|i| "John #{i}"}
          result = build_clients(names)
          get_index
          assigns(:count).should eq(Client.every(@event.id).count)
        end
      end
      
      describe "with scope_id set" do
        
        it "assigns clients base on scope" do
          names = ['A', 'B', 'C', 'D', 'E']
          expected_clients = build_clients(names)
          Client.stub(:todays).with(@event.id) {expected_clients}
          get_index(:scope => 'todays')
          assigns(:clients).should include(*expected_clients)
          assigns(:clients).size.should eq(expected_clients.size)
        end

        it "assigns counts based on scope" do
          counts = {'A' => 3}
          Client.stub(:todays).with(@event.id) { Client.every }
          Client.stub("get_counts").with(:todays, @event.id) { counts}
          get_index(:scope => 'todays')
          assigns(:counts).should eq(counts)
        end
        
        it "adds scope to link_params" do
          Client.stub(:needs_printing).with(@event.id) { Client.every }
          get_index(:scope => 'needs_printing')
          assigns(:link_params)[:scope].should eq(:needs_printing)
        end
      end
      
      describe "with offset set" do
      
        it "skips over clients" do
          names = (1..20).map {|i| "John #{i}"}
          build_clients(names)
          offset = 10
          expected = Client.every(@event).order('legal_name').offset(10)
          get_index(:offset => offset.to_s)
          assigns(:clients).map(&:legal_name).should match_array(expected.map(&:legal_name))
        end
        
        it "assigns offset to link_params" do
          get_index(:offset => '5')
          assigns(:link_params)[:offset].should eq(5)
        end
      end
      
      describe "with letter set" do
      
        it "limits the clients to that letter" do
          names = ((1..10).map {|i| "Richard #{i}"}).concat((1..8).map{|i| "William #{i}"})
          build_clients(names)
          expected = Client.every(@event).where(:first_letter => 'W')
          get_index(:letter => 'W')
          assigns(:clients).map(&:legal_name).should match_array(expected.map(&:legal_name))
        end
        
        it "does not assign letter to link params" do
          get_index(:letter => 'X')
          assigns(:link_params).should_not have_key(:letter)
        end
      end
    end
    
    describe "otherwise" do
      it "redirects to show" do
        account = login_with_rights
        get_index
        response.status.should redirect_to(:controller => :session, :action => :show)
      end
    end
  end

  describe "GET show" do
    it "assigns the requested client as @client"
  end

  describe "GET new" do
    it "assigns a new client as @client"
  end
  
  describe "POST verify" do
    before :each do
      @event = events(:pennsic_39)
    end
    
    def valid_params(options = {})
      {:legal_name => 'Test User', :address_1 => '100 Main St.', :kingdom => 'East'}.merge(options)
    end
    
    def invalid_params(options = {})
      options
    end

    def verify(params = {})
      post :verify, :event_id => @event.id, :client => params
    end
    
    it "requires authentication" do
      verify_needs_authorization do 
        verify valid_params
      end
    end
    
    describe "when as create_client rights" do
      before :each do 
        account = login_with_rights(:create_client)
      end

      describe "with valid params" do
        it "assigns a non-persisted  client as @client" do
          verify valid_params
          client = assigns(:client)
          client.should_not be_persisted
        end
        
        it "has the parameters in the client" do
          email = 'test@test.com'
          params = valid_params(:email => email)
          verify params
          assigns(:client).email.should eq(email)
        end
        
        it "renders verification" do
          verify valid_params
          response.should render_template('verification')
        end
      end
      
      describe "with invalid params" do
         it "assigns a non-persisted  client as @client" do
          verify invalid_params
          client = assigns(:client)
          client.should_not be_persisted
        end
        
        it "has the parameters in the client" do
          email = 'test@test.com'
          params = invalid_params(:email => email)
          verify params
          assigns(:client).email.should eq(email)
        end
        
        it "the client has errors" do
          verify invalid_params
          assigns(:client).errors.should_not be_empty
        end
        
        it "renders new" do
          verify invalid_params
          response.should render_template('new')
        end
      end
    end

    describe "otherwise" do
      
      it "is forbidden" do
        login_with_rights
        verify valid_params
        response.should be_forbidden
      end
    end
  end 

  describe "GET edit" do
    it "assigns the requested client as @client" 
  end

  describe "POST create" do
    before :each do
      @event = events(:pennsic_40)
    end
    
    def valid_params(options = {})
      {:legal_name => 'Test User', :address_1 => '100 Main St.', :kingdom => 'East'}.merge(options)
    end
    
    def create(client_params = {}, top_params = {})
      params = top_params
      params[:event_id] = @event.id.to_s
      params[:client] = client_params
      post :create, params
    end
    
    it "requires authentication" do
      verify_needs_authorization do 
        create valid_params
      end
    end
    
    describe "when has create_client rights" do
      
      before :each do 
        @account = login_with_rights(:create_client)
      end

      describe "with valid params" do
        it "assigns a newly created client as @client" do
          create valid_params
          client = assigns(:client)
          client.id.should_not be_nil
        end

        it "renders :new if commit = Edit" do
          create valid_params, :commit => 'Edit'
          response.should render_template("new")
        end
 
        it "does not persist client if commit = Edit" do
          create valid_params, :commit => 'Edit'
          assigns(:client).should_not be_persisted          
        end
       
        it "redirects to new client if guest" do
          @account.roles << roles(:guest)
          @account.save!
          create valid_params
          response.should redirect_to(new_event_client_path(@event))
        end
        
        it "redirect to client list if not guest" do
          create valid_params
          response.should redirect_to(event_clients_path(@event))
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved client as @client"

        it "re-renders the 'new' template"
      end
      
    end

    describe "otherwise" do
      
      it "is forbidden" do
        login_with_rights
        create valid_params
        response.should be_forbidden
      end
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
