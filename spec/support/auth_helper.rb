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
    response.status.should redirect_to(:new_session)
  end

  def verify_needs_right(right)
    login_with_no_rights
    yield
    response.status.should eq(403)
  end

  def admin_account
    @admin_account ||= Account.find_by_name('Admin')
  end
  
  def get_right(right_name)
    r = Right.find_by_name(right_name)
    return r if r
    r = Right.new(:name => right_name)
    r.save!
    return r
  end
  
  def login_with_rights(*rights)
    role = Role.new(:name => "login_test_#{rights.join('_')}")
    rights.each do |r|
      role.rights << get_right(r)
    end
    role.save!
    a = Account.new(:name => "test_#{role.name}", :password => "test_pwd")
    a.roles << role
    a.save!
    login(a)
    return a
  end
 
  def login_with_no_rights
    login_with_rights
  end
end
