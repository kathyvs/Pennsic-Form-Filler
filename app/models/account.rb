#
# Contains an account for this sysytem. Accounts as associated with projects, not people.
#
class Account < ActiveRecord::Base

  has_and_belongs_to_many :events
  has_and_belongs_to_many :roles

  validates :name, :presence => true, :uniqueness => true
  validates :password, :confirmation => true
  
  attr_reader :password
  attr_accessor :password_confirmation
  
  validate :password_must_be_present
  scope :every, lambda {|event_id| where('event_id = ?', event_id) }
  
  def self.login(name, password)
    account = find_by_name(name)
    if account && account.hashed_password == encrypt_password(password, account.salt)
      return account
    end
  end 

  def self.encrypt_password(password, salt)
    debugger if not salt
    Digest::SHA2.hexdigest(password + "lucky" + salt) 
  end
  
  def self.new_named(*args)
    NamedAccount.new(*args)
  end

  def password=(password)
    @password = password
    if password.present?
      generate_salt
      self.hashed_password = self.class.encrypt_password(password, salt)
    end
  end

  def admin?
    @is_admin ||= has_role?(:admin)
  end

  def has_role?(role)
    roles.member?(Role.find_by_name(role))
  end
  
  def password_must_be_present
    errors.add(:password, "Missing password") unless hashed_password.present? 
  end

  def has_right?(right_name)
    roles.detect do |role|
      role.has_right?(right_name)
    end
  end
  
  def update_roles(new_role_ids)
    new_roles = Role.where("id in (?)", new_role_ids)
    raise ActiveRecord::RecordNotFound.new unless new_role_ids.size == new_roles.count
    self.roles = new_roles
  end
  
  private

  def generate_salt
    self.salt = self.object_id.to_s + rand.to_s
  end
  
  CAN_PATTERN = /can_([a-z_]*)\?/
  def method_missing(m, *args, &block)
    match = CAN_PATTERN.match(m.to_s)
    if (match)
      right = match[1]
      has_right?(right)
    else
      super
    end
  end       

end

#
# Describes an account that is also a person
#
class NamedAccount < Account

  validates :sca_name, :presence => true, :uniqueness => true
  validates :contact_info, :presence => true, :uniqueness => true
    
  def self.model_name
    Account.model_name
  end
end
