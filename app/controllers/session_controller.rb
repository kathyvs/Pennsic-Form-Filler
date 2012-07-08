class SessionController < ApplicationController

  before_filter :authenticate, :except => [:new, :create] 
   
  def show
    controller = account.is_admin? ? :accounts : :events 
    redirect_to :controller => controller, :action => :index
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
      session[:account] = @account.id
      logger.info("Login = #{@login.inspect}")
      redirect_to(@login.last_url.blank? ? {:action => :show} : @login.last_url)
    else
      render :login
    end
  end
  
end
