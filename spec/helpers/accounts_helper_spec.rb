require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the AccountsHelper. For example:
#
# describe AccountsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe AccountsHelper do
  
  fixtures :roles
  
  describe "role_checkboxes" do
    
    before :each do
      @account = Account.new(:name => 'test')
      @account.roles << Role.find_by_name(:clerk)
      @account.roles << Role.find_by_name(:herald)
      @result = role_checkboxes(@account)
    end
    
    it "has a role for each role" do
      Role.all.each do |role|
        found = false
        @result.each do |checkbox, label|
          if checkbox.include?("value=\"#{role.id}")
            label.should include('label')
            found = true
          end
        end
        found.should be_true
      end
    end
    
    it "checks roles in account" do
      Role.all.each do |role|
        @result.each do |checkbox, label|
          if checkbox.include?("value=\"#{role.id}")
            if (@account.roles.include?(role))
              checkbox.should include('checked="checked"')
            else
              checkbox.should_not include('checked')
            end
          end
        end
      end
    end
  end
end
