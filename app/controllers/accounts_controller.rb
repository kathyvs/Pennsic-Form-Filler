class AccountsController < ApplicationController

  before_filter :authenticate, :except => [:new, :create]
 
  before_filter :can_view_accounts, :only => [:index]
  
  before_filter :can_edit_account_roles, :only => [:roles]
  # GET /accounts
  # GET /accounts.xml
  def index
    @accounts = Account.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @accounts }
    end
  end

  # GET /accounts/1
  # GET /accounts/1.xml
  def show
    unless account.can_view_accounts? || Integer(params[:id]) == account.id
      respond_forbidden and return 
    end
    
    begin
      @account = Account.find(params[:id])
     
      respond_to do |format|
        format.html # show.html.erb
      end
    rescue ActiveRecord::RecordNotFound
      render :file => 'public/404.html', :status => 404
    end
  end

  # GET /accounts/new
  # GET /accounts/new.xml
  def new
    @account = Account.new_named

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @account }
    end
  end

  # GET /accounts/1/edit
  def edit
    respond_forbidden and return unless account.can_modify_other_accounts? || params[:id] == account.id
    @account = Account.find(params[:id])
  end

  # POST /accounts
  def create
    @account = Account.new_named(params[:account])
    e = Event.current_event
    @account.events << e if e

    respond_to do |format|
      if @account.save
        session[:account] = @account.id
        format.html do 
          redirect_to(@account, :notice => 'Account was successfully created -- Contact a senior herald for activiation ')
        end
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /accounts/1
  # PUT /accounts/1.xml
  def update
    respond_forbidden and return unless account.can_modify_other_accounts? || params[:id] == account.id
    @account = Account.find(params[:id])

    respond_to do |format|
      if @account.update_attributes(params[:account])
        format.html { redirect_to(@account, :notice => 'Account was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # GET/PUT /accounts/1/roles
  def roles
    @role_account = Account.find(params[:id])
    if request.get?
      @roles = account.can_add_all_account_roles? ? Role.all : account.roles
    elsif request.put?
      new_role_ids = params[:roles] || {}
      param_error = {:text => "invalid params: #{params.inspect}", :status => 400}
      render(param_error) and return unless new_role_ids.respond_to?(:keys)
      begin
        @role_account.update_roles(new_role_ids.keys)
        @role_account.save!
        redirect_to(:accounts)
      rescue ActiveRecord::RecordNotFound
        render(param_error)
      end
    else
      respond_bad_method
    end
  end
end
