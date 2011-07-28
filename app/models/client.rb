class Client < ActiveRecord::Base
   belongs_to :event
   has_many :forms

  def self.find_with_event(client_id, event) 
     self.find_by_id_and_event_id(client_id, event)
  end

  def has_forms?
    not forms.empty?
  end
end
