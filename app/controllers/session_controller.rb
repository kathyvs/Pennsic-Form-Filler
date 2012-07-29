class SessionController < ApplicationController

  before_filter :authenticate, :except => [:new, :create] 
   
  def show
    if (account.admin?) 
      url = url_for(:accounts)
    elsif (account.has_role?(:guest) && account.events.size == 1)
      url = url_for(new_event_client_path(:event_id => account.events[0]))
    elsif (account.has_role?(:herald) && account.events.size == 1)
      url = url_for(event_clients_path(:event_id => account.events[0]))
    else
      url = url_for(:events)
    end
    redirect_to url
  end
  
  def new
    reset_session
    @account = nil
    @login = Login.new(:last_url => params[:return_to])
    render :login 
  end
  
  def create
    @account = nil
    @login = Login.new(params[:login])
    if @login.valid?
      @account = @login.login
    end
    if (@account)
      logger.info("Successfully logged in as #{@account.name}")
      session[:account] = @account.id
      redirect_to(@login.last_url.blank? ? {:action => :show} : @login.last_url)
    else
      logger.debug("Errors in login: #{@login.errors.inspect}")
      render :login
    end
  end
  
end
