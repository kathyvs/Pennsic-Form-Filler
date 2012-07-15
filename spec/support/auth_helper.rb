#This file contains helpers for handling basic authorization in tests

module AuthHelper
  def login(account_info)
    account = nil
    case account_info
    when Account
      account = account_info
    when Symbol
      account = accounts(account_info)
    when String
      account = Account.find_by_name(account_info)
    when Fixnum
      session[:account] = account_info and return
    else
      fail("Unknown login parameter: #{account_info.inspect}") and return
    end
    session[:account] = account.id
  end 

  def verify_needs_authorization
    yield
    response.status.should redirect_to(:session)
  end

  def verify_needs_admin
    login_non_admin
    yield
    response.status.should eq(403)
  end

  def admin_account
    @admin_account ||= Account.find_by_name('Admin')
  end
 
end
