require 'spec_helper'

describe Form do

  Form.types.select do |type, cls|
    it "creates a form of class #{cls} for type #{type}" do
      form = Form.create({:type => type})
      form.should be_a_kind_of(cls)
    end

    it "does not require that #{type} be a symbol" do
      form = Form.create({:type => type.to_s})
      form.should be_a_kind_of(cls)
    end

    it "also creates the correct form from #{cls}" do
      form = Form.create(:type => cls.to_s)
      form.should be_a_kind_of(cls)
    end

  end

  it "sets the other parameters on the form" do
    type = Form.types.keys.first
    params = {:client_id => 3, :herald => 'Test Herald', :type => type}
    form = Form.create(params)
    form.client_id.should eq(3)
    form.herald.should eq('Test Herald')
  end

  it "returns null for an unknown type" do
    bad_form = Form.create({:type => 'xxx'})
    bad_form.should be_nil
  end
  
end

describe NameForm do

  before :each do 
    @form = Form.create(:type => :name)
  end
  attr_reader :form

  it "has eight action type options plus blank" do
    action_types = form.action_type_options
    action_types.keys.should eq(["", :new, :resub_kingdom, :resub_laurel, :change_retain, :change_release, :change_holding, :appeal, :other].collect(&:to_s))
  end

  describe 'on full_action_type=' do
    it "sets action_type to 'New' on new and unsets action_change_type and resub " do 
      form.full_action_type = 'new'
      form.action_type.should eq("New")
      form.action_change_type.should eq("Off")
      form.resub_from.should eq("Off")
      form.full_action_type.should eq('new')
    end

    it "sets action_type to 'Resubmission' on :resub_kingdom, sets resub to 'Kingdom' and unsets action_change_type" do
      form.full_action_type = 'resub_kingdom'
      form.action_type.should eq('Resubmission')
      form.action_change_type.should eq('Off')
      form.resub_from.should eq('Kingdom')
      form.full_action_type.should eq('resub_kingdom')
    end

    it "sets action_type to 'Resubmission' on :resub_laurel, sets resub to 'Laurel' and unsets action_change_type" do
      form.full_action_type = 'resub_laurel'
      form.action_type.should eq('Resubmission')
      form.action_change_type.should eq('Off')
      form.resub_from.should eq('Laurel')
      form.full_action_type.should eq('resub_laurel')
    end

    it "sets action_type to 'Change' on :change_retain, sets action_change_type to 'Retain' and unsets resub" do
      form.full_action_type = 'change_retain'
      form.action_type.should eq('Change')
      form.action_change_type.should eq('Retain')
      form.resub_from.should eq('Off')
      form.full_action_type.should eq('change_retain')
    end

    it "sets action_type to 'Change' on :change_release, sets action_change_type to 'Release' and unsets resub" do
      form.full_action_type = 'change_release'
      form.action_type.should eq('Change')
      form.action_change_type.should eq('Release')
      form.resub_from.should eq('Off')
      form.full_action_type.should eq('change_release')
    end

    it "sets action_type to 'Holding' on change_holding and unsets action_change_type and resub " do 
      form.full_action_type = 'change_holding'
      form.action_type.should eq("Holding")
      form.action_change_type.should eq("Off")
      form.resub_from.should eq("Off")
      form.full_action_type.should eq('change_holding')
    end

    it "sets action_type to 'Appeal' on appeal and unsets action_change_type and resub " do 
      form.full_action_type = 'appeal'
      form.action_type.should eq("Appeal")
      form.action_change_type.should eq("Off")
      form.resub_from.should eq("Off")
      form.full_action_type.should eq('appeal')
    end

    it "sets action_type to 'Other' on other and unsets action_change_type and resub " do 
      form.full_action_type = 'other'
      form.action_type.should eq("Other")
      form.action_change_type.should eq("Off")
      form.resub_from.should eq("Off")
      form.full_action_type.should eq('other')
    end
  end
  
  describe "new_to_kingdom?" do
    NOT_NEW = [:resub_kingdom, :resub_laurel, :change_holding]
    NameForm.action_types.keys.each do |atype| 
      if NOT_NEW.include?(atype.to_sym)
        it "is not new for #{atype}" do
          form.full_action_type = atype
          form.should_not be_new_to_kingdom
        end
      else
        it "is new for #{atype}" do
          form.full_action_type = atype
          form.should be_new_to_kingdom
        end
      end
    end    
  end
  
  describe "content" do
    
    it 'uses submitted name if exists' do
      form.submitted_name = 'aaa'
      form.content.should eq('aaa')
    end
    
    it 'uses society name otherwise' do
      c = Client.new(:id => 1, :society_name => 'Test')
      form.submitted_name = ''
      form.client = c
      form.content.should eq(form.client.society_name)
    end
  end
  
  describe "oscar types" do
    
    it "is 'Name' when name_type is primary and action_type is not 'Change'" do
      form.name_type = 'Primary'
      form.full_action_type = 'New'
      form.oscar_type.should eq("Name")
    end
    
  end
end

describe DeviceForm do
  
  before :each do 
    @form = Form.create(:type => :device)
  end
  
  attr_reader :form

  describe "content" do
    it "uses blazon" do
      blazon = 'a test'
      form.blazon = blazon
      form.content.should eq(blazon)
    end
  end
end

describe BadgeForm do
  
  before :each do 
    @form = Form.create(:type => :badge)
  end
  
  attr_reader :form

  describe "content" do
    it "uses blazon" do
      blazon = 'a test'
      form.blazon = blazon
      form.content.should eq(blazon)
    end
  end
end

