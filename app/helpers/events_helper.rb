module EventsHelper
  
  def account_names(event)
    l = event.accounts.map {|a| a.name}
    l.join(', ')
  end
end
