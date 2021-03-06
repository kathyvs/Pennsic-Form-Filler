require 'pdf_forms'
require 'action_type'
require 'encoder'

class Form < ActiveRecord::Base
  extend DaudDecodable

  belongs_to :client
  attr_accessor :doc_pdf_content_type
  daud_decoded :documentation, :previous_kingdom, :blazon
  
  validates_format_of :doc_pdf_content_type, 
     :with => /application.pdf/,
     :message => "--- you can only upload PDF files",
     :allow_nil => true

  validates_length_of :doc_pdf, :maximum => 1.megabytes,
                      :message => 'File cannot be longer than 1 M'

  validate do |form|
    if form.has_doc_pdf? 
      begin
        unless PDFForms::PDFFile.valid_pdf?(form.doc_pdf)
          form.errors.add(:doc_pdf, 'Documentation cannot be encrypted')
        end
      rescue
        form.errors.add(:doc_pdf, 'Unable to read documentation')
      end
    else
      true
    end
  end
  
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
    name = client.display_name.downcase.gsub(/ /, '_') + '_' + self.class.label.to_s + id.to_s
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

  def action_type_options
    result = {'' => '---'}
    action_types.each_pair do |key, info|
      result[key] = info.display
    end
    result
  end

  def full_action_type
    action_types.each_pair do |key, info|
      return key if info.matches(self)
    end
    return nil
  end

  def full_action_type_display
    key = full_action_type
    action_types.has_key?(key) ? action_types[key].display : nil
  end

  def full_action_type=(new_value)
    self.action_type = 'Off'
    self.action_change_type = 'Off'
    self.resub_from = 'Off'
    if action_types.has_key?(new_value)
      action_types[new_value].set_values(self)
    end
  end

  def has_other_name_type?
    false
  end

  def has_previous_kingdom?
    false
  end

  def has_badge_list?
    false
  end

  def new_to_kingdom?
    key = full_action_type
    action_types.has_key?(key) ? action_types[key].new_to_kingdom? : true
  end
  
  def full_documentation
    documentation
  end
end

  
class NameForm < Form
  
  validates_length_of :full_documentation, :maximum => 1000,
                      :message => "Documentation is limited to 1000 characters; use the additional docs for longer documentation"

  daud_decoded :submitted_name, :authentic_text, :preferred_changes_text
  
  def self.label
    :name
  end

  def self.pdf_class
    PDFForms::IndividualName
  end

  Form.add_type(self)

  @pdf = nil

  @@action_types = {
    :new => ActionType::NEW,
    :resub_kingdom => ActionType::RESUB_KINGDOM,
    :resub_laurel => ActionType::RESUB_LAUREL,
    :change_retain => ActionType::CHANGE_RETAIN.with_display('Name change (retain old as alternate)'),
    :change_release => ActionType::CHANGE_RELEASE.with_display('Name change (release old name)'),
    :change_holding => ActionType::NAME_CHANGE_HOLDING,
    :appeal => ActionType::APPEAL,
    :other => ActionType::OTHER,
  }.with_indifferent_access
  cattr_reader :action_types

  def full_documentation
    result = (documentation || "").clone
    result << "\n " << 'Allows adding/deleting a word like "de" or "the" or changing language when the change is small' if is_intermediate
    return result
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
    return allowed.blank? ? ['None'] : allowed
  end

  def preferred_changes
    result = preferred_changes_type || ''
    result << ', ' unless result.empty? or preferred_changes_text.blank?
    result << preferred_changes_text unless preferred_changes_text.blank?
    return result
  end

  def no_holding_name
    boolean_to_state(no_holding_name_flag)
  end

  def has_other_name_type?
    true
  end
  
  def allowed_changes
    changes = :major
    if no_changes_major_flag
      if is_intermediate
        changes = :intermediate
      elsif no_changes_minor_flag
        changes = :no_changes
      else
        changes = :minor
      end
    end
    return changes
  end

  def allowed_changes=(changes)
    self.no_changes_major_flag = false
    self.no_changes_minor_flag = false
    self.is_intermediate = false
    case (changes || :major).to_sym
      when :no_changes
        self.no_changes_major_flag = true
        self.no_changes_minor_flag = true
      when :minor
        self.no_changes_major_flag = true
      when :intermediate
        self.no_changes_major_flag = true
        self.is_intermediate = true
    end
  end
  
  def content
    submitted_name.blank? ? client.society_name : submitted_name
  end
  
  def oscar_type
    case name_type
    when 'Alternate'
      'Alternate Name'
    when 'HouseHold'
      'Household Name'
    else
      'Name'
    end
  end
  
end

class DeviceForm < Form

  def self.label
    :device
  end

  def self.pdf_class
    PDFForms::Device
  end

  Form.add_type(self)

  @@action_types = {
    :new => ActionType::NEW,
    :resub_kingdom => ActionType::RESUB_KINGDOM,
    :resub_laurel => ActionType::RESUB_LAUREL,
    :change_retain => ActionType::CHANGE_RETAIN.with_display('Device change (retain old as badge)'),
    :change_release => ActionType::CHANGE_RELEASE.with_display('Device change (release old device)'),
    :appeal => ActionType::APPEAL,
    :other => ActionType::OTHER
  }.with_indifferent_access

  cattr_reader :action_types

  def has_previous_kingdom?
    true
  end
  
  def content
    blazon
  end
  
  def oscar_type
    'Device'
  end
end

    
class LozengeDeviceForm < DeviceForm

  def self.label
    :lozenge
  end

  def self.display_name
    "Device (Lozenge form)"
  end

  def self.pdf_class
    PDFForms::LozengeDevice
  end

  Form.add_type(self)
end

class BadgeForm < Form

  def self.label
    :badge
  end

  def self.pdf_class
    PDFForms::Badge
  end

  Form.add_type(self)

  @@action_types = {
    :new => ActionType::NEW,
    :resub_kingdom => ActionType::RESUB_KINGDOM,
    :resub_laurel => ActionType::RESUB_LAUREL,
    :change_retain => ActionType::CHANGE_RETAIN.with_display('Badge change (retain old badge)'),
    :change_release => ActionType::CHANGE_RELEASE.with_display('Badge change (release old badge)'),
    :appeal => ActionType::APPEAL,
    :other => ActionType::OTHER
  }.with_indifferent_access

  cattr_reader :action_types

  def has_badge_list?
    true
  end

  def is_joint
    boolean_to_state(is_joint_flag)
  end

  def to_release
    result = []
    result << release1 unless release1.blank?
    result << release2 unless release2.blank?
    return result
  end
  
  def content
    blazon
  end
  
  def oscar_type
    'Badge'
  end
end

class FieldlessBadgeForm < BadgeForm

  def self.label
    :fieldless
  end

  def self.display_name
    "Fieldless Badge"
  end

  def self.pdf_class
    PDFForms::FieldlessBadge
  end

  Form.add_type(self)
end
