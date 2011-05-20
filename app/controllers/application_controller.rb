class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :authenticate
  
  protected
  
  def authenticate
    authenticate_or_request_with_http_basic do |name, password|
      @account = Account.login(name, password)
    end
  end

  def require_admin
    if not (@account and @account.admin?) 
      render :text => 'Forbidden', :status => 403
      return false
    end
    return true
  end
end
