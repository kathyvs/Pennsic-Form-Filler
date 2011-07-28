class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :authenticate
  
  protected
  
  def authenticate
    logger.info('Authenticating')
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

  def respond_not_found 
    raise ActiveRecord::RecordNotFound.new
  end

  def require_event
    logger.info("Validating event #{params[:event_id]}")
    @event = Event.find_with_account(params[:event_id], @account)
    respond_not_found unless @event
  end

  def require_client
    logger.info("Validating client #{params[:client_id]}")
    @client = Client.find_with_event(params[:client_id], @event)
    respond_not_found unless @client
  end
end
