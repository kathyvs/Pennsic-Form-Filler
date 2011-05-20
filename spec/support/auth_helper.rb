#This file contains helpers for handling basic authorization in tests

module AuthHelper
  def http_login(name, password)
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(name, password)
  end 

  def verify_needs_authorization
    yield
    response.status.should eq(401)
  end

  def verify_needs_admin
    http_login_non_admin
    yield
    response.status.should eq(403)
  end

 
end
