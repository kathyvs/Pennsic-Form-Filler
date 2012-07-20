class Role < ActiveRecord::Base
  has_and_belongs_to_many :accounts
  has_and_belongs_to_many :rights
end
