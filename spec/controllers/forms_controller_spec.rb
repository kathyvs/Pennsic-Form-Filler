require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe FormsController do

  include AuthHelper
  fixtures :accounts, :events, :clients

  before :each do
    @event = events(:pennsic_40)
    @client = clients(:william)
  end
  
  def mock_form(stubs={})
    @mock_form ||= mock_model(Form, stubs).as_null_object
  end

  def get_with_login(*args)
    login(:herald)
    get(*args)
  end
  
  def run_with_client(method, cmd, rest = {})
    rest[:client_id] = @client.id
    rest[:event_id] = @event.id
    send(method, cmd, rest)
  end
  
  def get_with_client(cmd, rest = {})
    run_with_client :get, cmd, rest
  end
  

  def post_with_client(cmd, rest = {})
    run_with_client :post, cmd, rest
  end
  
  def put_with_client(cmd, rest = {})
    unless rest.has_key? :form
      rest[:form] = {}      
    end
    form = rest[:form]
    form[:society_name] = @client.society_name unless form.has_key? :society_name
    run_with_client :put, cmd, rest
  end
  
  def delete_with_client(cmd, rest = {})
    run_with_client :delete, cmd, rest
  end
  describe "GET show" do
  
    it "requires authentication" do
      get_with_client(:show, :id => 37)
      response.status.should redirect_to(:new_session)
    end
    
    describe "when can view all clients" do
      
      before :each do 
        account = login_with_rights_for_event(@event, :view_all_clients)
      end

      it "assigns the requested form as @form when exists" do
        Form.stub(:find).with("37") { mock_form }
        get_with_client :show, :id => "37"
        assigns(:form).should be(mock_form)
      end
      
      it "gives a RecordNotFount error when not exists" do
        expect { 
          get_with_client :show, :id => "111111"}.to raise_error(
              ActiveRecord::RecordNotFound)
      end
    end
     
    describe "otherwise" do
      it "redirects to session show" do
        Form.stub(:find).with("37") { mock_form }
        account = login_with_rights_for_event(@event)
        get_with_client :show, :id => "37"
        response.status.should redirect_to(
           :controller => :session, :action => :show)
      end
    end

  end

  describe "GET new" do
  
    it "requires authentication" do
      get_with_client(:new)
      response.status.should redirect_to(:new_session)
    end
    
    describe "when has edit_client rights" do
      
      before :each do 
        @account = login_with_rights_for_event(@event, :view_all_clients)
      end

      it "returns 400 if no client" do
        expect {
          get :new, :event_id => @event.id,  :client_id => '11111'
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
      
      it "gets the possible types when type is not set" do
        get_with_client :new
        assigns(:client).to_i.should eq(@client.id)
        assigns(:types).should eq(Form.types)
      end

      it "assigns a new form as @form when type is set" do
        NameForm.stub(:new) { mock_form }
        get_with_client :new, :type => 'name'
        assigns(:form).should be(mock_form)
      end
    end
    
    describe "otherwise" do
      it "redirects to session show" do
        account = login_with_rights_for_event(@event)
        get_with_client :new
        response.status.should redirect_to(
           :controller => :session, :action => :show)
      end
    end

  end

  describe "GET edit" do
    
    before :each do 
      @form_id = "37"
      Form.stub(:find).with("37") { mock_form }
    end
    
    it "requires authentication" do
      get_with_client(:new)
      response.status.should redirect_to(:new_session)
    end
    
    describe "when has view_client rights" do
      
      before :each do 
        @account = login_with_rights_for_event(@event, :view_all_clients)
      end

      it "assigns the requested form as @form" do
        get_with_client :edit, :id => @form_id
        assigns(:form).should be(mock_form)
      end
    end
    
    describe "otherwise" do
      it "redirects to session show" do
        account = login_with_rights_for_event(@event)
        get_with_client :edit, :id => "37"
        response.status.should redirect_to(
           :controller => :session, :action => :show)
      end
    end

  end

  describe "POST create" do
    it "requires authentication" do
      get_with_client(:new)
      response.status.should redirect_to(:new_session)
    end
    
    describe "when has view_client rights" do
 
      before :each do 
        @account = login_with_rights_for_event(@event, :view_all_clients)
      end
      
      describe "with valid params" do
        it "assigns a newly created form as @form" do
          Form.stub(:create).with({'these' => 'params'}) { mock_form(:save => true) }
          post_with_client :create, :form => {'these' => 'params'}
          assigns(:form).should be(mock_form)
        end

        it "redirects to client page" do
          Form.stub(:create) { mock_form(:save => true) }
          post_with_client :create, :form => {}
          response.should redirect_to(event_client_path(@client, :event_id => @event))
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved form as @form" do
          Form.stub(:create).with({'these' => 'params'}) { mock_form(:save => false) }
          post_with_client :create, :form => {'these' => 'params'}
          assigns(:form).should be(mock_form)
        end

        it "re-renders the 'new' template" do
          Form.stub(:create) { mock_form(:save => false) }
          post_with_client :create, :form => {}
          response.should render_template("new")
        end
      end
    end
    
    describe "otherwise" do
      it "redirects to session show" do
        account = login_with_rights_for_event(@event)
        Form.stub(:create) { mock_form(:save => true) }
        post_with_client  :create, :form => {}
        response.status.should redirect_to(
           :controller => :session, :action => :show)
      end
    end
  end

  describe "PUT update" do
    it "requires authentication" do
      Form.stub(:find) { mock_form(:update_attributes => true) }
      put_with_client(:update, :id => "37")
      response.status.should redirect_to(:new_session)
    end
    
    describe "when has view_client rights" do

      before :each do 
        @account = login_with_rights_for_event(@event, :view_all_clients)
      end

      describe "with valid params" do
        it "updates the requested form" do
          Form.stub(:find).with("37") { mock_form }
          mock_form.should_receive(:update_attributes).with(
            {'these' => 'params', 'society_name' => @client.society_name})
          put_with_client :update, :id => "37", :form => {'these' => 'params'}
        end

        it "assigns the requested form as @form" do
          Form.stub(:find).with("1") { mock_form(:update_attributes => true) }
          put_with_client :update, :id => "1"
          assigns(:form).should be(mock_form)
        end

        it "redirects to the client page" do
          Form.stub(:find) { mock_form(:update_attributes => true) }
          put_with_client :update, :id => "1"
          response.should redirect_to(event_client_path(@client, :event_id => @event))
        end
      end

      describe "with invalid params" do
        it "assigns the form as @form" do
          Form.stub(:find) { mock_form(:update_attributes => false) }
          put_with_client :update, :id => "1"
          assigns(:form).should be(mock_form)
        end

        it "re-renders the 'edit' template" do
          Form.stub(:find) { mock_form(:update_attributes => false) }
          put_with_client :update, :id => "1"
          response.should render_template("edit")
        end
      end
    end
    
    describe "otherwise" do
      it "redirects to session show" do
        account = login_with_rights_for_event(@event)
        Form.stub(:find) { mock_form(:save => true) }
        put_with_client  :update,  :id => '1'
        response.status.should redirect_to(
           :controller => :session, :action => :show)
      end
    end
  end

  describe "DELETE destroy" do
   it "requires authentication" do
      delete_with_client(:update, :id => "37")
      response.status.should redirect_to(:new_session)
    end
    
    describe "when has view_client rights" do

      before :each do 
        @account = login_with_rights_for_event(@event, :view_all_clients)
      end

      it "destroys the requested form" do
        Form.stub(:find).with("37") { mock_form }
        mock_form.should_receive(:destroy)
        delete_with_client :destroy, :id => "37"
      end

      it "redirects to the clients list" do
        Form.stub(:find) { mock_form }
        delete_with_client :destroy, :id => "1"
        response.should redirect_to(event_client_path(@client, :event_id => @event))
      end
      
    end
    describe "otherwise" do
      it "redirects to session show" do
        account = login_with_rights_for_event(@event)
        Form.stub(:find) { mock_form(:save => true) }
        delete_with_client  :destroy,  :id => '1'
        response.status.should redirect_to(
           :controller => :session, :action => :show)
      end
    end
  end

  describe "GET print_setup" do
    
    it "requires authentication" do
      get_with_client(:print_setup, :id => 37)
      response.status.should redirect_to(:new_session)
    end
    
    describe "when can edit clients" do
      
      before :each do 
        account = login_with_rights_for_event(@event, :edit_client)
      end

      describe "when can print directly" do
        
        before :each do
          @print_info = PrintInfo.new(:printers => {'a' => 'b'})
          @controller.set_print_info @print_info
        end
        
        it "assigns the requested form as @form" do
          Form.stub(:find).with("37") { mock_form }
          get_with_client :print_setup, :id => "37"
          assigns(:form).should be(mock_form)
        end
      
        it "assigns the controller's print info" do
          Form.stub(:find).with("37") { mock_form }
          get_with_client :print_setup, :id => "37"
          assigns(:print_info).should be(@print_info)
        end
        
        it "assigns the home param to @home" do
          Form.stub(:find).with("37") { mock_form }
          get_with_client :print_setup, :id => "37", :home => 'aaa'
          assigns(:home).should eq('aaa')
          
        end
      end 
      
    end
      
    describe "otherwise" do
      it "redirects to session show" do
        Form.stub(:find).with("37") { mock_form }
        account = login_with_rights_for_event(@event)
        get_with_client :print_setup, :id => "37"
        response.status.should redirect_to(
           :controller => :session, :action => :show)
      end
    end

  end

  describe "POST print_setup" do
    
    it "requires authentication" do
      post_with_client(:print_setup, :id => 37)
      response.status.should redirect_to(:new_session)
    end
    
    describe "when can edit clients" do
      
      before :each do 
        account = login_with_rights_for_event(@event, :edit_client)
      end

      describe "when valid" do
        
        before :each do
          @print_info = mock(PrintInfo)
          @controller.set_print_info @print_info
          @form = mock_form
          Form.stub(:find).with("37") { @form }
        end
      
        describe "when printing directly" do 
          
          it "sends print to print_info" do
            @printed = false
            @print_info.stub(:print).with(@form, printer = "a") { @printed = true }
            post_with_client :print, :printer => "a", :print_action => 'print', :id => "37", :home => :client
            @printed.should be_true
          end

          it "redirects to client page if home is 'client'" do
            @print_info.stub(:print).with(@form, printer = "b") { }
            post_with_client :print, :printer => "b", :id => "37", :print_action => 'print', :home => 'client'
            response.should redirect_to(event_client_path(@client, :event_id => @event))
          end

          it "redirects to form page if home is 'form'" do
            @print_info.stub(:print).with(@form, printer = "c") { }
            post_with_client :print, :printer => "c", :id => "37", :print_action => 'print', :home => 'form'
            response.should redirect_to(event_client_form_path(@form, 
                :client_id => @client, :event_id => @event))
          end

          it "redirects to event page if home is 'event'" do
            @print_info.stub(:print).with(@form, printer = 'd') { }
            post_with_client :print, :printer => "d", :id => "37", :print_action => 'print', :home => 'event'
            response.should redirect_to(event_path(@event))
          end
          
          it "sets the form 'printed' variable to true" do
            flag_set = false
            @form.stub(:printed=).with(true) { flag_set = true }
            @print_info.stub(:print).with(@form, printer = "b") { }
            post_with_client :print, :printer => "b", :id => "37", :print_action => 'print', :home => 'client'
            flag_set.should be_true
            @form.should be_saved
          end
        end
        
        describe "when downloading file" do
          
          it "redirects to show pdf" do
            post_with_client :print, :print_action => 'download', :id => "37"
            response.should redirect_to(event_client_form_path(@form, 
              :client_id => @client, :event_id => @event, :format => 'pdf'))
          end

          it "sets the form 'printed' variable to true" do
            flag_set = false
            @form.stub(:printed=).with(true) { flag_set = true }
            post_with_client :print, :id => "37", :print_action => 'download', :home => 'client'
            flag_set.should be_true
            @form.should be_saved
          end
        end
        
        describe "otherwise" do
          
          it "returns 400 error" do
            post_with_client :print, :id => "37", :print_action => 'bad', :home => 'client'
            response.status.should eq(400)
          end
        end
      end 
      
    end
      
    describe "otherwise" do
      it "redirects to session show" do
        account = login_with_rights_for_event(@event)
        post_with_client :print_setup, :id => "37"
        response.status.should redirect_to(
           :controller => :session, :action => :show)
      end
    end

  end
end
