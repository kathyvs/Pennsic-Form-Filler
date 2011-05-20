class Event < ActiveRecord::Base
  belongs_to :account
  has_many :clients
  
end
