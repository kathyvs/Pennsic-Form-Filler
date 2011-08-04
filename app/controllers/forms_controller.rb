class FormsController < ApplicationController

  before_filter :require_event, :require_client

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

  # POST /event/:event_id/client/:client_id/forms
  # POST /event/:event_id/client/:client_id/forms.xml
  def create
    @form = Form.create(params[:form]) 
    
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
      format.html { redirect_to(forms_url) }
      format.xml  { head :ok }
    end
  end
end
