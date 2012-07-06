class SessionController < ApplicationController

  before_filter :authenticate, :except => [:new] 
   
  def home
    redirect_to :controller => :accounts, :action => :index
  end
  
  def new
    session[:account] = nil
    render :login
  end
end
