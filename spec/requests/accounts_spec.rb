require 'spec_helper'
require 'support/request_help'

describe "Accounts" do
  include AuthorizationHandler

  fixtures :accounts
 
  describe "GET /accounts" do
    it "requires account to be admin" do
      get accounts_path, nil,  auth_key => auth_value(:pennsic)
      response.status.should eq(403)
    end
    it "lists all accounts for the admin" do
      get accounts_path, nil, auth_key => admin_auth
      response.status.should eq(200)
    end
  end
end
