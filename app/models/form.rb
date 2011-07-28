require 'pdf_forms'

class Form < ActiveRecord::Base
  belongs_to :client
  @@cls_types = {}.with_indifferent_access

  def self.types
    @@cls_types
  end

  def self.add_type(cls) 
    @@cls_types[cls.label.to_s] = cls
    @@cls_types[cls.name] = cls
  end

  def self.display_name
    label.to_s.capitalize
  end

  def self.create(params)
    logger.warn("types: #{types.inspect}");
    cls = types[params[:type]]
    cls ? cls.new(params) : nil
  end

  def type_name
    self.class.display_name
  end

  def pdf
    self.class.pdf_class.new
  end

  def pdf_data
    pdf.create_pdf(self)
  end
end

  
class NameForm < Form
  @@label = :name
  @@pdf_class = PDFForms::IndividualName
  cattr_reader :label, :pdf_class

  Form.add_type(self)

  @pdf = nil

  
end

