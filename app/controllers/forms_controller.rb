class FormsController < ApplicationController

  before_filter :require_event, :require_client
  before_filter :redirect_unless_edit_client, :only => [:print_setup, :print]
  before_filter :redirect_unless_view_all_clients, :only => [:show, 
                  :new, :edit, :create, :update, :destroy]
  
  def set_print_info(print_info)
    @print_info = print_info
  end
  
  # GET /forms/1
  # GET /forms/1.pdf
  def show
    @form = Form.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @form }
      format.pdf { send_data @form.pdf_data, :type => :pdf, :filename => @form.file_name }
    end
  end


  # GET /client/:client_id/forms/new
  # GET /client/:client_id/forms/new.xml
  def new
    if params[:type]
      if @form = Form.create(params.slice(:type))
        @form.client = @client
        @form.date_submitted = Date.today
        @form.needs_review = true
        @form.herald = account.sca_name
        @form.heralds_email = account.contact_info
        respond_to do |format|
          format.text { render :text => @form.inspect }
          format.html # new.html.erb 
          format.xml  { render :xml => @form }
        end
        return
      else
        @error = "Unknown type: #{params[:type]} from params #{params.inspect}"
      end
    end
    @client = params[:client_id]
    @types = Form.types
    render :action => 'types'
  end

  # GET /client/:client_id/forms/1/edit
  def edit
    @form = Form.find(params[:id])
  end
  
  # GET /client/:client_id/forms/1/print
  def print_setup
    @form = Form.find(params[:id])
    @home = params[:home]
    print_info
  end
  
  def print
    @form = Form.find(params[:id])
    @form.printed = true
    @form.save!
    case params[:print_action]
    when 'print'
      print_info.print @form, printer = params[:printer]
      case params[:home]
      when 'client'
        redirect_to event_client_path(@client, :event_id => @event)
      when 'event'
        redirect_to event_path(@event)
      else 
        redirect_to event_client_form_path(@form, :client_id => @client, :event_id => @event)
      end
    when 'download'
      redirect_to event_client_form_path(@form, :client_id => @client, :event_id => @event, :format => 'pdf')
    else 
      render :status => :bad_request, :text => "Bad Request"
    end
  end

  # POST /event/:event_id/client/:client_id/forms
  # POST /event/:event_id/client/:client_id/forms.xml
  def create
    @form = Form.create(params[:form]) 
    update_name(params[:society_name])
    respond_to do |format|
      if @form.save
        format.html { redirect_to(event_client_path(@client, :event_id => @event), 
                                  :notice => 'Form was successfully saved.') }
        format.xml  { render :xml => @form, :status => :created, :location => @form }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @form.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /event/:event_id/client/:client_id/forms/1
  # PUT /event/:event_id/client/:client_id/forms/1.xml
  def update
    @form = Form.find(params[:id])
    update_name(params[:society_name])
    respond_to do |format|
      if @form.update_attributes(params[:form])
        format.html { redirect_to(event_client_path(@client, :event_id => @event), 
                                  :notice => 'Form was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @form.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /event/:event_id/client/:client_id/forms/1
  # DELETE /event/:event_id/client/:client_id/forms/1.xml
  def destroy
    @form = Form.find(params[:id])
    @form.destroy

    respond_to do |format|
      format.html { redirect_to(event_client_path(@client, :event_id => @event)) }
      format.xml  { head :ok }
    end
  end
  
  private 
  def update_name(society_name)
    logger.info "Checking #{society_name} against #{@client.society_name}"
    return if !society_name || society_name.blank? || society_name == @client.society_name
    logger.info "Updating #{society_name}"
    @client.society_name = society_name
    @client.save!
    logger.info "Client name is now #{@client.society_name}"
  end
  
  def print_info
    @print_info ||= PrintInfo.from_config(FormFiller::Application.config)
  end
end
