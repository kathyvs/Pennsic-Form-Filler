class SessionController < ApplicationController

  before_filter :authenticate, :except => [:new] 
   
  def home
    redirect_to :controller => :accounts, :action => :index
  end
end
