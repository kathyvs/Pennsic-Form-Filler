class Event < ActiveRecord::Base
  has_many :clients
  has_and_belongs_to_many :accounts
  
  def self.find_with_account(id, account)
    Event.find_by_id_and_account_id(id, account)
  end

end
