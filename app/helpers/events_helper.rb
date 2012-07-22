module EventsHelper
  
  def account_names(event)
    l = event.accounts.map {|a| a.name}
    l.length > 5 ? '<many>' : l.join(', ')
  end
  
  def current_event_options(events)
    @coll = []
    @coll <<  Event.new(:title => '--No Current Event--')
    current_id = nil
    events.each do |e|
      @coll << e
      current_id = e.id if e.current?
    end
    options_from_collection_for_select(@coll, "id", "title", current_id)
  end
end
