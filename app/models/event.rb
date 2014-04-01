class Event < ActiveRecord::Base
  has_many :clients
  has_and_belongs_to_many :accounts
  
  def self.find_all_for_account(account)
    account.events
  end

  def self.find_with_account(id, account)
    account.events.where(:id => id).first
  end
  
  def self.current_event
    Event.where(:is_current => true).first
  end

  def current?
    is_current
  end
  
  def kingdoms
    result = Hash.new(0)
    Client.every(id).each do | client |
      result[client.kingdom] += 1
    end
    result
  end
end
