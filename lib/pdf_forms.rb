require 'java'
require 'pdf_writer'

module PDFForms

  class PDFForm
    @@pdf_keys = {
      :address_1 => 'Address_1',
      :address_2 => 'Address_2',
      :birth_date => 'DOB',
      :branch_name => 'Branch_Name',
      :email => 'Email',
      :phone_number => "Phone_Number",
      :herald => "Consulting_Herald",
      :herald_contact => "Herald_Contact",
      :kingdom => 'Kingdom',
      :legal_name => 'Legal_Name',
      :resub_from => "Resub",
      :society_name => 'Society_Name'
    }
    cattr_reader :pdf_keys
    cattr_reader :pdf_file

    def initialize(reader = nil) 
      @reader = reader || com.itextpdf.text.pdf.PdfReader.new(pdf_file)
    end

    def create_pdf(form)
      filler = PDFFiller.new(@reader)
      client = form.client
      pdf_keys.each_pair do |prop, field|
        filler.set_field(field, form.send(prop)) if form.respond_to?(prop)
        filler.set_field(field, client.send(prop)) if client.respond_to?(prop)
      end
      filler.get_pdf
    end
      
    def pdf_dir
      File.join Rails.public_path, "files"
    end

    def pdf_file
      File.join pdf_dir, self.class.pdf_file
    end

    def collection(field_sym) 
      fields = @reader.acro_fields
      field = pdf_keys[field_sym]
      fields.get_appearance_states(field).map do |s|
        s == 'Off' ? '---' : s
      end
    end
  end

  class Name < PDFForm
    @@pdf_keys = PDFForm.pdf_keys.merge(
      :action_type => "Action",
      :action_type_other => "Action_Other",
      :action_change_type => "Change",
      :authentic_flags => "Authentic",
      :authentic_text => "Authentic_Changes",
      :documentation => "Name_Documentation",
      :no_changes_major => "No_Changes-Major",
      :no_changes_minor => "No_Changes_Minor",
      :no_holding_name => "No_Holding_Name",
      :original_returned => "Date Returned",
      :preferred_changes_type => "Acceptable",
      :preferred_changes_text => "Name_Changes",
      :previous_kingdom => "Previous_Kingdom",
      :previous_name => "Previous_Name",
      :submitted_name => "Submitted_Name"
  )
  end

  class IndividualName < Name
    @@pdf_keys = Name.pdf_keys.merge(
      :gender => "Gender",
      :gender_name => "NameGender",
      :name_type => "Name_Type",
      :name_type_other => "Name_Type_Other"
    )

    @@pdf_file = 'Generic_name-i_Form.pdf'
  end

  class BranchName < Name
    @@pdf_keys = Name.pdf_keys.merge({})
  end
end
