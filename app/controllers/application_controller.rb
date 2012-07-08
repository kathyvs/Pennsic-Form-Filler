class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :authenticate, :except => [:session]
  
  protected
  
  def authenticate
    unless account
      redirect_to url_for(:new_session)
    end
  end
  
  def account
    logger.info("Account id = #{session[:account]}")
    @account ||= Account.where(:id => session[:account])[0]
    logger.info("Account = #{@account}")
    return @account
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
