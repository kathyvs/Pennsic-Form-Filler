module FormsHelper

  def self.with_default(val, hash = {})
    hash.default = val
    return hash
  end

  @@name_info = {
    :authentic_flags => {
      :display => {'LangCulture' => 'Language and/or culture',
                   'Period' => 'Time period'},
      :sort_key => with_default('')
    },
    :gender => {
      :display => {},
      :sort_key => with_default('', 'Male' => '1', 'Female' => '2')
    },
    :gender_name => {
      :display => {'DontCare' => "Don't care"},
      :sort_key => with_default('', 'Male' => '1', 'Female' => '2', 'DontCare' => '3')
    },
    :kingdom => {
      :display => {},
      :sort_key => with_default('', "\303\206thelmearc" => '0')
    },
    :preferred_changes_type => {
      :display => {'LangCulture' => 'Language and/or culture'},
      :sort_key => with_default('')
    },
    :name_type => {
      :display => {'HouseHold' => 'Household',
                   'registered' => 'Already registered',
                   'submitted_previously' => 'Previously submitted',
                   'submitted_with' => 'Submitted with this form'},
      :sort_key => with_default('', 'Primary' => '1', 'submitted_previously' => 'Z')
    }
      
  }

  def form_form_path(form)
    if (form.id)
       event_client_form_path(form, :event_id => @event, :client_id => @client)
    else
       event_client_forms_path(:event_id => @event, :client_id => @client)
    end
  end

  TYPE_NAMES = {
    :name => 'Name Type',
    :device => 'Name is',
    :badge => 'Name is',
    :lozenge => 'Name is'
  }
  def name_type_name(form)
    TYPE_NAMES[form.class.label]
  end

  def form_types
    result = {}
    Form.types.values.each do |t|
      result[t.display_name] = t.label
    end
    logger.warn("Result = #{result.inspect}")
    result
  end

  def pdf_select(f, field, form = @form)
    f.collection_select field, pdf_collection(field, form.pdf), :first, :last
  end

  def pdf_collection(field, pdf)
    values = pdf.collection(field)
    pairs = values.collect do |v|
      [v, display_name(field, v)]
    end
    pairs.sort_by { |v| sort_key(field, v.last)}
  end

  def allowed_changes_select
    values = {:no_changes => 'No Changes',
              :minor => 'Minor only',
              :intermediate => 'Intermediate and minor',
              :major => 'All changes'}
  end
  
  def form_path(f, opts = {})
    build_form_path(:event_client_form_path, f, opts)
  end

  def edit_form_path(f, opts = {})
    build_form_path(:edit_event_client_form_path, f, opts)
  end

  def print_form_path(f, opts = {})
    build_form_path(:print_setup_event_client_form_path, f, opts)
  end
  
  #private

  def display_info(field)
    @@name_info.has_key?(field) ? @@name_info[field][:display] : {}
  end

  def sort_info(field)
    if @@name_info.has_key?(field)
      @@name_info[field][:sort_key]
    else
      Hash.new('')
    end
  end

  def display_name(field, value)
    field_names = display_info(field)
    (field_names and field_names.has_key?(value)) ? field_names[value] : value
  end

  def sort_key(field, value)
    sort_info(field)[value] + value
  end

  def build_form_path(method, form, opts) 
    opts[:client_id] = @client
    opts[:event_id] = @event
    send(method, form, opts)
  end

  def needs_review_class(form)
    form.needs_review ? 'needs_review' : (form.printed ? 'printed' : '')
  end

  def full_action(form)
    result = ""
    if form.action_type == 'Other'
      result << form.action_type_other
    else
      result << form.action_type
    end
    if form.action_type == 'Change'
      result << ", #{form.action_change_type}"
    end
    return result
  end

  def changes_text(flag)
    flag ? 'no' : 'yes'
  end

end
