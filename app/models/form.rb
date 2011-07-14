class Form < ActiveRecord::Base
  belongs_to :client
  @@types = {}

  cattr_reader :types
  def self.add_type(type, cls) 
    @@types[type] = cls
  end

  def self.new_with_type(type) 
    cls = @@types[type]
    cls ? cls.new : nil
  end

  @@pdf_keys = {
    :address_1 => 'Address_1',
    :address_2 => 'Address_2',
    :birth_date => 'DOB',
    :branch_name => 'Branch_Name',
    :email => 'Email',
    :kingdom => 'Kingdom',
    :legal_name => 'Legal_Name',
    :society_name => 'Society_Name'
  }


end

class NameForm < Form
  Form.add_type(:name, self)
end


  
