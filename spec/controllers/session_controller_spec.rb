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
    
    it "saves a last_url_value" do
      url = "test/test"
      request.env["HTTP_REFERER"] = url
      get :new
      assigns(:last_url_value).should eq(url)
    end
  end
  
  describe "POST create" do
    
  end
  
  describe "DELETE destory" do
    
  end
end
