
module AuthorizationHandler

  DEF_ACCOUNTS = {:admin => 'Admin', :pennsic => 'Pennsic', 
                  :wp => 'War Practice'}

  def login(user, pwd = nil)
    if not pwd
      key = user
      user = DEF_ACCOUNTS[key]
      pwd = "#{key}_pwd"
    end
    post "/session", :login => ["login"]
  end

  def login_admin≈
    auth_value(:admin)
  end
  
end
