require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the SessionHelper. For example:
#
# describe SessionHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe SessionHelper do
  
  describe "for field_classes" do 
    
    before :each do
      @login = Login.new(:name => 'a')
      @login.valid?
    end
    
    it "returns 'field' when no errors" do
      helper.field_classes(:name).should eq('field')  
    end
    
    it "returns 'field field_with_errors' when errors" do
      helper.field_classes(:password).should eq('field field_with_errors')
    end
  end
end
