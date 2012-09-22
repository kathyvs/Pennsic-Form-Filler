xml.lois do
  xml.loi(:date => Date.today.to_s(:db), :issued => 'n', :lettertype => 8) do
    xml.kingdom(@kingdom)
    xml.submitters do
      @clients.each do |client|
        if (client.has_forms?) 
          xml.submitter do
            xml.filing_name(d client.society_name)
            xml.legal_name(client.legal_name)
            xml.saddress1(client.address_1)
            xml.saddress2(client.address_2)
            xml.branch(d client.branch_name)
            xml.submittergender(client.short_gender)
            xml.phone(client.phone_number)
            xml.dob(client.birth_date)
            xml.email(client.email)
            xml.submissions do
              if (client.has_primary_name_form? && client.has_device_form?)
                token = "T#{client.id}F#{client.primary_name_form.id}"
              else
                token = nil
              end
              client.forms.each do |form|
                options = {:type => form.oscar_type, 
                           :isnew => yes_no(form.new_to_kingdom?)}
                if form.type_name == "Name" && form.name_type == "Primary" && token
                  options[:pairtoken] = token
                end
                xml.submission(options) do
                  xml.subdate(form.date_submitted.to_s(:db))
                  xml.herald(d form.herald)
                  xml.hcontact(form.heralds_email)
                  xml.content(d form.content)
                  xml.laurelappeal(yes_no(form.action_type == 'Appeal'))
                  if (form.type_name == 'Name')
                    xml.nomajor(yes_no(form.no_changes_major_flag))
                    xml.nominor(yes_no(form.no_changes_minor_flag))
                    tag = nil
                    case form.preferred_changes_type
                    when "Meaning"
                      tag = :meaning
                    when "Sound"
                      tag = :sound
                    when "Spelling"
                      tag = :spelling
                    when "LangCulture"
                      tag = :culture
                    end
                    unless tag.blank?
                      xml.tag!(tag, d(form.preferred_changes_text))
                    end
                    unless (form.authentic_text && form.authentic_flags == '---')
                      auth_options = {:period => 'n', :language => 'n', :culture => 'n'}
                      case form.authentic_flags
                      when "Period"
                        auth_options[:period ] = 'y'
                      when 'LangCulture'
                        auth_options[:language] = 'y'
                      end
                      xml.authentic(d(form.authentic_text), auth_options)
                    end
                    xml.allow_holding(yes_no(!form.no_holding_name_flag))
                    xml.submissiongender(form.gender_name[0..0])
                  end
                  notes = form.full_documentation || ""
                  unless form.notes.blank?
                    notes << "\n" << form.notes
                    notes = notes.gsub("\n", "<br/>\n")
                  end
                  xml.notes(d notes)
                  if form.type_name == "Device" && token
                    xml.paired(token)
                  end
                  if form.action_type == "Change" || form.action_type == "Holding"
                    holding = form.type_name == "Name" && form.action_type == "Holding"
                    xml.change('y', :from_holding => yes_no(holding))
                    disposition = form.action_change_type == "Release" ? "release" : "retain"
                    old = form.type_name == "Name" && form.name_type == "Primary" ? client.society_name : ""
                    xml.changefrom(old, :disposition => disposition)
                  end
                  unless form.previous_name.blank?
                    xml.pname(form.previous_name)
                  end
                  unless form.previous_kingdom.blank? || form.previous_kingdom.starts_with?('-') 
                    xml.pking(form.previous_kingdom)
                  end
                  unless form.original_returned.blank?
                    xml.prdate(form.original_returned)
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end



