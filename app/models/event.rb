class Event < ActiveRecord::Base
  belongs_to :account
  has_many :clients
  
  def self.find_with_account(id, account)
    Event.find_by_id_and_account_id(id, account)
  end

end
