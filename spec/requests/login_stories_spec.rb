require 'spec_helper'

describe "LoginStories" do
  urls = ["/accounts", "/events", "/session"]
  
  describe "when not logged in" do
    urls.each do |url|
      it "goes to login page" do
        get url
        response.status.should redirect_to(:new_session)
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
              assert_select "input[name=?]", f
            end
          end
        end

      end
      
      it "gives error when logging in incorrectly" do
        post "/session", :name => 'bad', :password => 'bad'
      end
    end
  
  end
  
end
