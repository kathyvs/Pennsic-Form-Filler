require 'spec_helper'

describe SessionController do
  
  include AuthHelper
  fixtures :accounts
  
  describe "GET show" do
    
    it "redirects to new when not logged in" do
      get :show
      response.should redirect_to(:action => "new")
    end
    
    it "redirects to accounts when admin" do
      login(admin_account)
      get :show
      response.should redirect_to(:controller => "accounts", :action => "index")
    end
    
    it "otherwise redierects to events" do
      login("Pennsic")
      get :show
      response.should redirect_to(:controller => "events", :action => "index")
    end    
   end
  
  describe "GET new" do
    it "shows the login view" do
      get :new
      response.should render_template(:login)
    end
    
    it "clears the session if logged in" do
      login("Pennsic")
      get :new
      response.should be_ok
      session[:account].should be_nil
    end
    
    it "saves a last_url value" do
      url = "test/test"
      request.env["HTTP_REFERER"] = url
      get :new
      assigns(:login).last_url.should eq(url)
    end
  end
  
  describe "POST create" do
    
    it "rerenders login on invalid input" do
      post :create, :login => {:name => 'bad'}
      response.should render_template(:login)
      assigns(:login).errors.should_not be_empty
      session[:account].should be_nil
    end
    
    it "rerenders login on invalid password" do
      post :create, :login => {:name => "Pennsic", :password => "bad"}
      response.should render_template(:login)
      assigns(:login).errors.should_not be_empty
    end
    
    it "sets session on valid input" do
      account = accounts(:pennsic)
      post :create, :login => {:name => account.name, :password => "pennsic_pwd"}
      session[:account].should eq(account.id)
    end

    it "redirects to last_url on valid input" do
      account = accounts(:pennsic)
      url = "http://www.test.com"
      post :create, :login => {:name => account.name, :password => "pennsic_pwd", 
        :last_url => url}
      response.should redirect_to(url)
    end
    
    it "redirects to '/session' when last_url does not exist" do
      account = accounts(:admin)
      post :create, :login => {:name => account.name, :password => "admin_pwd"}
      response.should redirect_to(:action => :show) 
    end
  end
  
  describe "DELETE destory" do
    
  end
end
