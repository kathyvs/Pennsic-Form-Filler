require 'spec_helper'
# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe AccountsController do

  include AuthHelper
  include ModelHelper
  fixtures :accounts, :roles, :accounts_roles

  def norm_account
    @norm_account ||= accounts(:clerk)
  end

  def login_non_admin
    login(norm_account)
  end

  def login_admin
    login(admin_account)
  end

  def valid_params
    {'name' => 'newacc', 'password' => 'secret',
     'password_confirmation' => 'secret'}
  end

  def invalid_params
    {'name' => 'bad', 'password' => '',
     'password_confirmation' => 'xx'}
  end


  describe "GET index" do
    it "requires admin" do 
      verify_needs_admin do
        login_non_admin
        get :index
      end
    end

    it "assigns all accounts as @accounts" do
      Account.stub(:all) { [norm_account, admin_account] }
      login_admin
      get :index
      assigns(:accounts).should eq([norm_account, admin_account])
    end
  end

  describe "GET show" do
    it "requires admin" do 
      verify_needs_admin do
        get :show, :id => '22'
      end
    end
    it "assigns the requested account as @account" do
      login_admin
      get :show, :id => norm_account.id.to_s
      assigns(:account).should eq(norm_account)
    end
    it "returns 404 when id is invalid" do
      login_admin
      get :show, :id => 100000
      response.status.should == 404
    end
  end

  describe "GET new" do
    it "requires admin" do 
      verify_needs_admin do
        get :new
      end
    end
    it "assigns a new named account as @account" do
      login_admin
      get :new
      assigns(:account).should be_new
      assigns(:account).should be_an_instance_of(NamedAccount)
    end
  end

  describe "GET edit" do
    it "requires admin" do 
      verify_needs_admin do
        get :edit, :id => '37'
      end
    end
    it "assigns the requested account as @account" do
      login_admin
      get :edit, :id => norm_account.id.to_s
      assigns(:account).should eq(norm_account)
    end
  end

  describe "POST create" do

    it "requires admin" do 
      verify_needs_admin do
        get :create, :account => valid_params
      end
    end
    describe "with valid params" do
      it "assigns a newly created account as @account" do
        login_admin
        post :create, :account => valid_params
        new_account = assigns(:account)
        new_account.name.should eq(valid_params['name'])
        new_account.should be_persisted
      end

      it "redirects to the created account" do
        login_admin
        post :create, :account => valid_params
        new_account = assigns(:account)
        response.should redirect_to(account_url(new_account))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved account as @account" do
        login_admin
        post :create, :account => invalid_params
        assigns(:account).should be_new
        assigns(:account).name.should == invalid_params['name']
      end

      it "re-renders the 'new' template" do
        login_admin
        post :create, :account => invalid_params
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    
    it "requires admin" do 
      verify_needs_admin do
        put :update, :id => norm_account.id, :account => valid_params
      end
    end

    describe "with valid params" do
      def run_put
        login_admin
        put :update, :id => norm_account.id.to_s, :account => valid_params
      end
      it "updates the requested account" do
        run_put
        changed_account = Account.find(norm_account.id)
        Account.login(valid_params['name'], valid_params['password']).should eq(changed_account)
      end

      it "assigns the requested account as @account" do
        run_put
        assigns(:account).should eq(norm_account)
      end

      it "redirects to the account" do
        run_put
        response.should redirect_to(account_url(norm_account))
      end
    end

    describe "with invalid params" do
      def run_put
        login_admin
        put :update, :id => norm_account.id.to_s, :account => invalid_params
      end

      it "does not modify the account" do
        run_put
        saved_account = Account.find(norm_account.id)
        saved_account.name.should == norm_account.name
      end

      it "assigns the account as @account" do
        run_put
        assigns(:account).should eq(norm_account)
      end

      it "re-renders the 'edit' template" do
        run_put
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "requires admin" do 
      verify_needs_admin do
        delete :destroy, :id => norm_account.id
      end
    end

    it "destroys the requested account" do
      login_admin
      delete :destroy, :id => norm_account.id
      Account.exists?(norm_account.id).should be_false
    end

    it "redirects to the accounts list" do
      login_admin
      delete :destroy, :id => norm_account.id
      response.should redirect_to(accounts_url)
    end
  end

end

