
module AuthorizationHandler

  DEF_ACCOUNTS = {:admin => 'Admin', :pennsic => 'Pennsic Guest', 
                  :wp => 'War Practice Guest', :clerk => 'Clerk'}

  def login_as(user, pwd = nil)
    if not pwd
      key = user
      user = DEF_ACCOUNTS[key]
      pwd = "#{key}_pwd"
    end
    post "/session", :login => {:name => user, :password => pwd}
    session[:account].should_not be_nil
  end

  def login_as_admin
    login_as(:admin)
  end
  
end
