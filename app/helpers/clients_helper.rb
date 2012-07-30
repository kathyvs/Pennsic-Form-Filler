module ClientsHelper

  def client_url(client)
    event_client_url(client, :event_id => @event)
  end

  def client_form_url(client) 
    if (client.id) 
      client_url(client)
    elsif @account.has_role?(:guest)
      verify_event_clients_path(:event_id => @event)
    else
      event_clients_path(:event_id => @event)
    end
  end

  def clients_path(params = nil)
    params ||= {}
    params[:event_id] = @event
    event_clients_path(params)
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
    result = client.forms.to_a.find {|f| f.needs_review || f.printed}
    result ? needs_review_class(result) : ""
  end

  def current_scope
    descr = Client.scope_names[@scope.to_sym].gsub('Show', 'showing').titleize
  end

  def update_clients_path(options)
    params = @link_params.merge(options)
    clients_path(params)
  end
  
  def offset_range
    first = (@link_params[:offset] || 0).to_i
    last = first + @clients.size
    return first..last
  end
  
  def previous_offset
    result = offset_range.first - @link_params[:limit]
    result < 0 ? 0 : result
  end
  
  def next_offset
    offset_range.last
  end

  def show_range(r)
    return "#{r.first + 1} - #{r.last}"
  end
end
