require 'spec_helper'

describe Account do
  describe "fetch by username and password" do
    fixtures :accounts
    
    [:admin, :pennsic, :war_practice, :clerk, :senior, :herald].each do |a|
      it "should be able to login #{a} with correct password" do
        expected_account = accounts(a)
        account = Account.login(expected_account.name, "#{a}_pwd")
        account.should eq(expected_account)
        account.should be_valid
      end

      it "should not be able to login #{a} with incorrect password" do
       account = Account.login(a, "bad")
       account.should be_nil
      end
    end

    it "should not be able to login unknown account name" do
      account = Account.login("unknown", "bad")
      account.should be_nil
    end
#http://railshotspot.blogspot.com/2008/07/rspec-fixtures-vs-mocks.html
  end

  describe "admin?" do
    fixtures :accounts, :roles, :accounts_roles
    
    it "is true for the admin" do
      accounts(:admin).should be_admin
    end
    
    it "is not true for clerk" do
      accounts(:clerk).should_not be_admin
    end
  end

  describe "validation" do
    
    def validate(cls, override)
      params = default_params.merge(override)
      cls.new(params)
    end

    def verify_default
      account = validate
      account.should be_valid
    end
    
    def verify_non_empty_name
      account = validate('name' => '')
      account.should have(1).error_on(:name)
    end
    
    def verify_non_empty_password
      account = validate('password' => '', 'password_confirmation' => '')
      account.should have(1).error_on(:password)
    end
    
    describe Account do
    
      def default_params
        {'name' => 'newName', 'password' => 'secret', 
         'password_confirmation' => 'secret'}
      end

      def validate(override = {})
        super(Account, override)
      end

      it "should be valid with default params" do
        verify_default
      end

      it "should require a non-empty name" do
        verify_non_empty_name
      end

      it "should require a unique name" do
        Account.new(default_params.merge({'sca_name' => '', 'contact_info' => ''})).save
        account = validate
        account.should have(1).error_on(:name)
      end
    
      it "should require a non-empty password" do
        verify_non_empty_password
      end

   end
   
   describe NamedAccount do
   
     def default_params
        {'name' => 'newName', 'password' => 'secret',  'password_confirmation' => 'secret',
         'sca_name' => 'SCA name', 'contact_info' => '111-22-3333'}
      end

      def validate(override = {})
        super(NamedAccount, override)
      end

      it "should be valid with default params" do
        verify_default
      end

      it "should require a non-empty name" do
        verify_non_empty_name
      end

      it "should require a unique name, SCA name, and contact" do
        NamedAccount.new(default_params).save
        account = validate
        account.should have(1).errors_on(:name)
        account.should have(1).errors_on(:sca_name)
        account.should have(1).errors_on(:contact_info)
      end
    
      it "should require a non-empty password" do
        verify_non_empty_password
      end

      it "should require password_confirmation to match password" do
        account = validate('password_confirmation' => 'other')
        account.should have(1).error_on(:password)
      end
      
      it "should required a non-empty SCA name" do
        account = validate("sca_name" => "")
        account.should have(1).error_on(:sca_name)
      end

      it "should required a non-empty contact" do
        account = validate("contact_info" => "")
        account.should have(1).error_on(:contact_info)
      end
    end
  end
end

