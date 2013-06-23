class EventsController < ApplicationController
  
  before_filter :can_modify_event, {:only => [:new, :edit, :create, :update]}
  
  # GET /events
  # GET /events.xml
  def index
    if @account.can_modify_event?
      if params.has_key?(:id)
        @events_for = Account.find(params[:id])
        response_not_found unless @events_for
        @events = Event.find_all_for_account(@events_for)
      else
        @events_for = nil
        @events = Event.all
      end
    else
      @events_for = @account
      @events = Event.find_all_for_account(@account)
    end
    @events = @events.sort_by(&:title)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    if (@account.can_modify_event?)
      @event = Event.find(params[:id])
    else 
      @event = Event.find_with_account(params[:id], @account)
    end
    respond_not_found unless @event
    redirect_to(event_clients_path(:event_id => @event.id))
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @event = Event.new
    setup_accounts
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/1/edit
  def edit
    #requie(:modify_event)
    @event = Event.find(params[:id])
    setup_accounts
  end

  # POST /events
  # POST /events.xml
  def create
    @event = Event.new(params[:event])
    @event.account_ids = (params[:non_members] ||{}).keys
    @event.accounts << account
    respond_to do |format|
      if @event.save
        format.html { redirect_to(events_url, :notice => "Event #{@event.title} was successfully created.") }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        setup_accounts
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = Event.find(params[:id])
    respond_to do |format|
      keys = @event.account_ids
      keys += params[:non_members].keys if params[:non_members]
      params[:event] ||= {}
      params[:event][:account_ids] = keys
      if @event.update_attributes(params[:event])
        format.html { redirect_to(events_url, :notice => "Event #{@event.title} was successfully created.") }
        format.xml  { head :ok }
      else
        setup_accounts
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  def list_kingdoms
  
  end
  #GET /events/1/kingdom/East
  def kingdom
    @event = Event.find(params[:id])
    respond_not_found unless @event
    @kingdom = params[:kingdom].gsub(/^AE/, "\xc3\x86").capitalize
    @clients = Client.where(:kingdom => @kingdom, :event_id => @event).order(:society_name)
    respond_to do |format|
      format.text { render(:template => 'events/by_kingdom') }
      format.xml { render(:template => 'events/by_kingdom')}
    end
  end
  
  #GET/PUT /events/current
  def current
    current_event = Event.current_event
    if request.get?
      respond_not_found unless current_event
      redirect_to(current_event)
    elsif request.put?
      if (current_event)
        current_event.is_current = false
        current_event.save!
      end
      e = Event.find(params[:event_id])
      respond_not_found unless e
      e.is_current = true
      e.save!
      redirect_to :events
    elsif
      respond :text => "unknown method", :status => 405
    end
  end
  
  private
  
  def setup_accounts
    @accounts = Account.all
  end
end
