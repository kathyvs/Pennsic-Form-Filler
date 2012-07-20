
module FixtureHelper

  def account_fixtures
    [:accounts, :roles, :accounts_roles]
  end
  
  def event_fixtures
    [:events, :accounts_events]
  end
  
  def all_fixtures(*fixture_lists)
    total = fixture_lists.flatten
    fixtures(*total)
  end
  
end