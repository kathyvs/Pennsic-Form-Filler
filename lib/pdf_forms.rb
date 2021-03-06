require 'java'
require 'pdf_writer'

module PDFForms

  class PDFFile

    def self.valid_pdf?(data)
      reader =  com.itextpdf.text.pdf.PdfReader.new(data.to_java_bytes)
      !reader.encrypted?
    end
    
    def self.pdf_pages(data)
      reader =  com.itextpdf.text.pdf.PdfReader.new(data.to_java_bytes)
      reader.number_of_pages
    end
  end


  class PDFForm
    class << self; attr_accessor :pdf_keys end

    @pdf_keys = {
      :action_change_type => "Change",
      :action_type => "Action",
      :action_type_other => "Action_Other",
      :address_1 => 'Address_1',
      :address_2 => 'Address_2',
      :birth_date => 'DOB',
      :branch_name => 'Branch_Name',
      :date_submitted => 'Date_Submitted',
      :email => 'Email',
      :phone_number => "Phone_Number",
      :herald => "Consulting_Herald",
      :heralds_email => "Herald_Contact",
      :kingdom => 'Kingdom',
      :legal_name => 'Legal_Name',
      :previous_kingdom => "Previous_Kingdom",
      :resub_from => "Resub",
      :society_name => 'Society_Name'
    }

    def initialize(reader = nil) 
      @reader = reader
    end

    def reader
      @reader ||= com.itextpdf.text.pdf.PdfReader.new(pdf_file)
    end

    def create_pdf(form)
      filler = PDFFiller.new(reader)
      client = form.client
      pdf_keys.each_pair do |prop, field|
        filler.set_field(field, form.send(prop)) if form.respond_to?(prop)
        filler.set_field(field, client.send(prop)) if client.respond_to?(prop)
      end
      filler.add_extra_pages(form.doc_pdf) if form.has_doc_pdf?
      filler.get_pdf
    end
      
    def pdf_dir
      File.join Rails.public_path, "files"
    end

    def pdf_file
      File.join pdf_dir, self.class.pdf_file
    end

    def pdf_keys
      self.class.pdf_keys
    end

    def collection(field_sym) 
      fields = reader.acro_fields
      field = pdf_keys[field_sym]
      states = fields.get_appearance_states(field)
      if (states)
        states.map do |s|
          s == 'Off' ? '---' : s
        end
      else
          ["Unable to find states for #{field}"]
      end
    end

  end

  class Name < PDFForm
  end
  
  Name.pdf_keys = PDFForm.pdf_keys.merge(
    :authentic_flags => "Authentic",
    :authentic_text => "Authentic_Changes",
    :full_documentation => "Name_Documentation",
    :no_changes_major => "No_Changes-Major",
    :no_changes_minor => "No_Changes_Minor",
    :no_holding_name => "No_Holding_Name",
    :original_returned => "Date_Returned",
    :preferred_changes_type => "Acceptable",
    :preferred_changes_text => "Name_Changes",
    :previous_name => "Previous_Name",
    :submitted_name => "Submitted_Name"
                                        )

  class IndividualName < Name
    def self.pdf_file
      'Generic_name-i_Form.pdf'
    end
  end

  IndividualName.pdf_keys = Name.pdf_keys.merge(
    :gender => "Gender",
    :gender_name => "NameGender",
    :name_type => "Name_Type",
    :name_type_other => "Name_Type_Other"
                                     )

  class BranchName < Name
#    @pdf_keys = Name.pdf_keys.merge({})
  end

  BranchName.pdf_keys = Name.pdf_keys.merge({})

  class Device < PDFForm
    
    def self.pdf_file
      'Generic_device_Form.pdf'
    end
  end

  Device.pdf_keys = PDFForm.pdf_keys.merge(
    :blazon => 'Blazon',
    :name_type => 'Name_Status',
    :restricted_charges => 'Restricted_Charges'
    )

  class LozengeDevice < PDFForm
    def self.pdf_file
      'Generic_device-lozenge_Form.pdf'
    end
  end

  LozengeDevice.pdf_keys = Device.pdf_keys

  class Badge < Device

    def self.pdf_file
      'Generic_badge_Form.pdf'
    end
  end

  Badge.pdf_keys = Device.pdf_keys.merge(
    :associated_name => "Associated_name",
    :co_owner_name => 'Co-Owner_Name',
    :is_joint => 'Joint',
    :release1 => 'Release1',
    :release2 => 'Release2'
  )

  class FieldlessBadge < Badge

    def self.pdf_file
      'Generic_badge-fieldless_Form.pdf'
    end
  end

  FieldlessBadge.pdf_keys = Badge.pdf_keys

end

