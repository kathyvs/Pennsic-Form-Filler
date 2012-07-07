class SessionController < ApplicationController

  before_filter :authenticate, :except => [:new] 
   
  def show
    redirect_to :controller => :accounts, :action => :index
  end
  
  def new
    reset_session
    @account = nil
    @last_url_value = request.env["HTTP_REFERER"]
    render :login
  end
end
