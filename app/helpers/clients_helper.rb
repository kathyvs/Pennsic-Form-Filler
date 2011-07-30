module ClientsHelper

  def client_url(client)
    event_client_url(client, :event_id => @event)
  end

  def client_form_url(client) 
    if (client.id) 
      client_url(client)
    else
      event_clients_path(:event_id => @event)
    end
  end

  def clients_path
    event_clients_path(:event_id => @event)
  end

  def client_path(client)
    event_client_path(client, :event_id => @event)
  end

  def edit_client_path(client)
    edit_event_client_path(client, :event_id => @event)
  end

  def new_client_path
    new_event_client_path(:event_id => @event)
  end

  def client_needs_review_class(client)
    (client.forms.collect {|f| needs_review_class(f)}).first
  end

end
