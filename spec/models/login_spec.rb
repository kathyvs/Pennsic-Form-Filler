require 'spec_helper'

describe Login do

  describe "on validation" do

    before :each do 
      @params = {:name => 'Pennsic', :password => 'pennsic_pwd'}
    end
      
    [:name, :password].each do |f|
      it "requires #{f}" do
        @params[f] = nil
        login = Login.new(@params)
        verify_invalid(login, f)
      end
    end

    it "is valid on default params" do
      login = Login.new(@params)
      login.should be_valid
    end
    
    it "calls login on Account on login" do
      login = Login.new(:name => 'good', :password => "pwd")
      account = Account.new(:name => 'good')
      Account.stub(:login, ['good', 'pwd']) { account }
      login.login.should equal(account)
    end
     
    it "sets an error on login if account is nil" do
      login = Login.new(:name => 'bad', :password => 'bad_pwd')
      Account.stub(:login, ['bad', 'bad_pwd']) {nil}
      login.login.should be_nil
      login.errors.should_not be_empty
    end
    
    def verify_invalid(login, field = nil)
      login.should_not be_valid
      login.errors.should have_key(field) if field
    end
  end
end