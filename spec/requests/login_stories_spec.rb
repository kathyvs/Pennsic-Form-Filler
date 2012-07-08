require 'spec_helper'

describe "LoginStories" do
  urls = ["/accounts", "/events", "/session"]
  
  describe "when not logged in" do
    urls.each do |url|
      it "#{url} goes to login page" do
        get url
        response.status.should redirect_to(
            :controller => :session, :action => :new, :return_to => url)
      end
    end
    
    describe "login" do
      describe "login form" do
        before :each do 
          get "/session/login"
        end

        ['name', 'password'].each do |f|
          it "renders a form with a #{f} field" do
            assert_select "form" do
              assert_select 'input[name=?]', "login[#{f}]"
            end
          end
        end

      end
      
      describe "login process" do
        before :each do 
          @name = "test"
          @password = 'test-pwd'
          Account.create!(:name => @name, :password => @password)
        end
        
        it "gives error when logging in incorrectly" do
          post "/session", :login => {:name => 'bad', :password => 'bad'}
          assert_select "#error_explanation"
        end
      
        it "goes to last_url when logged in successfully" do
          url= "http://test.com"
          post "/session", :login => {:name => @name, :password => @password, 
                                      :last_url => url}
          response.should redirect_to(url)
        end
      end
    end
  
  end
  
end
