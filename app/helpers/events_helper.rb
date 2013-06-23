require 'daud_coder'

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
  
  def yes_no(bool)
    bool ? 'y' : 'n'
  end
  
  def d(s)
    s ? DaudCoder.from_daud(s) : ""
  end
  
  def split_accounts(event, accounts)
    members = []
    nonmembers = []
    accounts.each do |account|
      if account.events.include?(event)
        members << account
      else
        nonmembers << account
      end
    end
    {:members => members, :nonmembers => nonmembers}
  end
end
