class AddAccountsEventsJoin < ActiveRecord::Migration
  class Account < ActiveRecord::Base; end
  class Event < ActiveRecord::Base
    has_and_belongs_to_many :accounts
  end
  def self.up
    create_table 'accounts_events', :id => false do |t|
      t.column 'event_id', :integer
      t.column 'account_id', :integer
    end
    Event.all.each do |e|
      e.accounts << Account.find(e.account_id)
    end
  end
  
  def self.down
    drop_table 'accounts_events'
  end
end
