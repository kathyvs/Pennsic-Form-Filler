require 'spec_helper'
require 'support/request_help'

describe "Accounts" do
  include AuthorizationHandler

  fixtures :accounts
 
  describe "when not logged in" do
  end
  
  describe "as non-admin" do 
    before :each do
      login_as :pennsic
    end
     
    describe "GET /accounts" do
      it "requires account to be admin" do
        get accounts_path
        response.status.should eq(403)
      end
    end
  end
  
  describe "as admin" do
    before :each do
      login_as_admin
    end
    
    describe 'GET /accounts' do
      it "lists all accounts for the admin" do
        get accounts_path
        response.status.should eq(200)
      end
    end
  end
end
