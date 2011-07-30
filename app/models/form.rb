require 'pdf_forms'

class Form < ActiveRecord::Base
  belongs_to :client
  attr_accessor :doc_pdf_content_type

  validates_format_of :doc_pdf_content_type, 
     :with => /application.pdf/,
     :message => "--- you can only upload PDF files",
     :allow_nil => true

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

  def file_name
    name = client.society_name.downcase.gsub(/ /, '_') + '_' + self.class.label.to_s + id.to_s
  end

  def doc_upload=(doc_field)
    self.doc_pdf_content_type = doc_field.content_type.chomp
    self.doc_pdf = doc_field.read
  end

  def has_doc_pdf?
    doc_pdf and not doc_pdf.empty?
  end

  def doc_pdf_pages
    PDFForms::PDFFile.pdf_pages(doc_pdf)
  end

  def boolean_to_state(flag)
    flag ? 'Yes' : 'Off'
  end

end

  
class NameForm < Form
  @@label = :name
  @@pdf_class = PDFForms::IndividualName
  cattr_reader :label, :pdf_class

  Form.add_type(self)

  @pdf = nil

  @@action_types = {
    :new => {:display => "New", :values => {:action_type => "New"}},
    :resub_kingdom => {
      :display => "Resubmission (Kingdom)", 
      :values => {:action_type => 'Resubmission',
                  :resub_from => 'Kingdom'}},
    :resub_laurel => {
      :display => "Resubmission (Laurel)",
      :values => {:action_type => 'Resubmission',
                  :resub_from => 'Laurel'}},
    :change_retain => {
      :display => "Name change (retain old as alternate)",
      :values => {:action_type => 'Change',
                  :action_change_type => 'Retain'}},
    :change_release => {
      :display => "Name change (release old name)",
      :values => {:action_type => 'Change',
                  :action_change_type => 'Release'}},
    :change_holding => {
      :display => "Name change from holding name",
      :values => {:action_type => 'Holding'}},
    :appeal => {
      :display => "Appeal",
      :values => {:action_type => 'Appeal'}},
    :other => {
      :display => "Other",
      :values => {:action_type => 'Other'}},
  }.with_indifferent_access
  
  def action_types
    result = {'' => '---'}
    @@action_types.each_pair do |key, info|
      result[key] = info[:display]
    end
    result
  end

  def full_action_type
    @@action_types.each_pair do |key, info|
      is_same = info[:values].to_a.all? do |prop, value|
        self.send(prop) == value
      end
      return key if (is_same)
    end
    return nil
  end

  def full_action_type_display
    key = full_action_type
    @@action_types.has_key?(key) ? @@action_types[key][:display] : ''
  end

  def full_action_type=(new_value)
    self.action_type = 'Off'
    self.action_change_type = 'Off'
    self.resub_from = 'Off'
    if @@action_types.has_key?(new_value)
      @@action_types[new_value][:values].each_pair do |prop, value|
        method = "#{prop}=".to_sym
        self.send(method, value)
      end
    end
  end

  def no_changes_minor
    boolean_to_state(no_changes_minor_flag)
  end

  def no_changes_major
    boolean_to_state(no_changes_major_flag)
  end

  def changes_allowed
    allowed = []
    allowed << 'Minor' unless no_changes_minor_flag
    allowed << 'Major' unless no_changes_major_flag
    return allowed
  end

  def preferred_changes
    result = preferred_changes_type
    result << ', ' unless result.empty?
    result << preferred_changes_text
    return result
  end

  def no_holding_name
    boolean_to_state(no_holding_name_flag)
  end

end

