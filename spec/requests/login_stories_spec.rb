require 'spec_helper'

describe "LoginStories" do
  urls = ["/accounts", "/events", "/session"]
  
  describe "when not logged in" do
    urls.each do |url|
      it "goes to login page" do
        get url
        puts(response.methods.sort)
        response.status.should redirect_to(:new_session)
      end
    end
    
    describe "login" do
      it "gives error when logging in incorrectly" do
        post "/session", :name => 'bad', :password => 'bad'
      end
    end
  
  end
  
end
