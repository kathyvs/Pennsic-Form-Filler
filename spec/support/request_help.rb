
module AuthorizationHandler

  DEF_ACCOUNTS = {:admin => 'Admin', :pennsic => 'Pennsic', 
                  :wp => 'War Practice'}

  def auth_key
    'HTTP_AUTHORIZATION'
  end

  def auth_value(user, pwd = nil)
    if not pwd
      key = user
      user = DEF_ACCOUNTS[key]
      pwd = "#{key}_pwd"
    end
    ActionController::HttpAuthentication::Basic.encode_credentials(user, pwd)  
  end

  def admin_auth
    auth_value(:admin)
  end
  
end
