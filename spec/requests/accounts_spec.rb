require 'spec_helper'
require 'ruby-debug'

describe "Accounts" do
  fixtures :accounts
  def admin_auth
    ActionController::HttpAuthentication::Basic.encode_credentials("admin", "admin_pwd")
  end
  describe "GET /accounts" do
    it "requires account to be admin" do
      get accounts_path, nil,  'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials("pennsic", "pennsic_pwd")
      response.status.should eq(403)
    end
    it "lists all accounts for the admin" do
      get accounts_path, nil, 'HTTP_AUTHORIZATION' => admin_auth
      response.status.should eq(200)
    end
  end
end
