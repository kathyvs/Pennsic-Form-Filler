require 'decode_map'

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :authenticate, :except => [:session, :accounts]

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
  
  def respond_forbidden
    render :text => 'Forbidden', :status => 403
  end
  
  def respond_bad_method
    render :text => "unknown method", :status => 405
  end
  
  def require(right_method)
    unless account and account.send(right_method) 
      respond_forbidden
      return false
    end
  end
  
  def redirect_when_missing(right)
    unless account and account.has_right?(right)
      redirect_to :controller => :session, :action => :show
      return false
    end
  end

  def require_event
    logger.debug("Validating event #{params[:event_id]}")
    @event = Event.find_with_account(params[:event_id], @account)
    respond_not_found unless @event
  end

  def require_client
    logger.info("Validating client #{params[:client_id]}")
    @client = Client.find_with_event(params[:client_id], @event)
    respond_not_found unless @client
  end
  
  CAN_PATTERN = /^can_([a-z_]*)/
  REDIRECT_PATTERN = /^redirect_unless_([a-z_]*)/
  def method_missing(m, *args, &block)
    m = m.to_s
    case m
    when CAN_PATTERN
      return require("#{m}?")
    when REDIRECT_PATTERN
      return redirect_when_missing(REDIRECT_PATTERN.match(m)[1])
    else
      logger.error "Unable to find method #{m} in class #{self.class}"
      super
    end
  end       

end
