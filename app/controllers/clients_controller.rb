class ClientsController < ApplicationController

  MAX_SIZE = 40
  
  before_filter :require_event
  before_filter :can_create_client, :only => [:create, :verify]
  before_filter :redirect_unless_view_all_clients, :only => [:index, :show]
  before_filter :redirect_unless_create_client, :only => [:new]
  
  def client_url
    event_client_url(@client, :event_id => @event)
  end
  
  # GET /clients
  # GET /clients.xml
  def index
    limit = (params[:limit] || MAX_SIZE).to_i
    offset = (params[:offset] || 0).to_i
    @scope = (params[:scope] || :every).to_sym
    search = Client.send(@scope, @event.id).order('society_name, legal_name')
    if (params.has_key?(:letter)) 
      letter = params[:letter].strip
      logger.debug("Limiting to letter #{letter}")
      search = search.where(:first_letter => letter)
    end
    @count = search.count
    puts "Count = #{@count.inspect}" unless @count.instance_of?(Fixnum)
    @clients = search.offset(offset).limit(limit)
    @counts = Client.get_counts(@scope, @event.id)
    @link_params = {:scope => @scope, :limit => limit}
    @link_params[:offset] = offset if (offset > 0) 
  end

  # GET /clients/1
  # GET /clients/1.xml
  def show
    @client = Client.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @client }
    end
  end

  # GET /clients/new
  # GET /clients/new.xml
  def new
    @client = Client.new
    @client.event_id = @event.id
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @client }
    end
  end

  # GET /clients/1/edit
  def edit
    return unless redirect_unless(:edit_client)
    @client = Client.find(params[:id])
  end

  def verify
    @client = Client.new(params[:client])
    if @client.valid?
      render "verification"
    else
      render :action => :new
    end
  end
  
  # POST /clients
  # POST /clients.xml
  def create
    @client = Client.new(params[:client])
    if (params[:commit] == 'Edit')
      @client.valid?
      render :action => :new
    else
      respond_to do |format|
        if @client.save
          format.html { redirect_to(@account.has_role?(:guest) ? new_event_client_path(@event)\
                              : event_clients_path(@event), 
                           :notice => 'Client was successfully created.') }
          format.xml  { render :xml => @client, :status => :created, :location => @client }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @client.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /clients/1
  # PUT /clients/1.xml
  def update
    @client = Client.find(params[:id])

    respond_to do |format|
      if @client.update_attributes(params[:client])
        format.html { redirect_to(client_url, :notice => 'Client was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @client.errors, :status => :unprocessable_entity }
      end
    end
  end

end
