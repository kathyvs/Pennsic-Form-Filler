class Role < ActiveRecord::Base
  extend ActiveSupport::Memoizable

  has_and_belongs_to_many :accounts
  has_and_belongs_to_many :rights
  
  def has_right?(right)
    rights.where("name = ?", right).count > 0
  end
  memoize :has_right?
end
