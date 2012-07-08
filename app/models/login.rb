class Login
  include ActiveModel::Validations
  
  attr_accessor :name
  attr_accessor :password
  attr_accessor :last_url
  attr_accessor :errors
  
  validates_presence_of :name, :password
  
  def initialize(assigns = nil)
    @errors = ActiveModel::Errors.new(self)
    if (assigns)
      assigns.each do |k, v|
        send("#{k}=", v)
      end
    end
  end
  
  def login
    account = Account.login(name, password)
    errors[:base] << "Unable to find name or password" unless account
    return account
  end

  # Dummy stub to make validtions happy.
  def save
  end

  # Dummy stub to make validtions happy.
  def save!
  end

  # Dummy stub to make validtions happy.
  def new_record?
    false
  end

  # Dummy stub to make validtions happy.
  def update_attribute
  end
   
end