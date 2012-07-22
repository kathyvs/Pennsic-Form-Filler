class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :authenticate, :except => [:session]
  
  protected
  
  def authenticate
    unless account
      redirect_to :controller => "session", :action => "new", 
                  :return_to => request.env["REQUEST_URI"]
      return false
    end
  end
  
  def account
    @account ||= Account.where(:id => session[:account])[0]
  end

  def require_admin
    if !(account && account.admin?) 
      render :text => 'Forbidden', :status => 403
      return false
    end
    return true
  end

  def respond_not_found 
    raise ActiveRecord::RecordNotFound.new
  end
  
   def require(right_method)
    unless account and account.send(right_method) 
      render :text => 'Forbidden', :status => 403
      return false
    end
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
  
  CAN_PATTERN = /can_([a-z_]*)/
  def method_missing(m, *args, &block)
    m = m.to_s
    case m
    when CAN_PATTERN
      return require("#{m}?")
    else
      super
    end
  end       

end
