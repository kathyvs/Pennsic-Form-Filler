class Client < ActiveRecord::Base
   belongs_to :event
   has_many :forms
end
