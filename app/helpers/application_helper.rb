module ApplicationHelper
  
  def logged_in?
    @account
  end
  
  def login_name
    @account.name
  end
end
