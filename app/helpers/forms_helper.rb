module FormsHelper

  def self.with_default(val, hash = {})
    hash.default = val
    return hash
  end

  @@name_info = {
    :action_type => {
      :display => {},
      :sort_key => with_default('b')
    },
    :gender => {
      :display => {},
      :sort_key => with_default('')
    },
    :kingdom => {
      :display => {},
      :sort_key => with_default('')
    }
  }

  puts @@name_info

  def form_types
    result = {}
    Form.types.values.each do |t|
      result[t.display_name] = t.label
    end
    logger.warn("Result = #{result.inspect}")
    result
  end

  def pdf_collection(field, pdf = PDFForms::PDFForm.new)
    values = pdf.collection(field)
    pairs = values.collect do |v|
      [v, display_name(field, v)]
    end
    pairs.sort_by { |v| sort_key(field, v.last)}
  end

  def form_path(f, opts = {})
    build_form_path(:event_client_form_path, f, opts)
  end

  def edit_form_path(f, opts = {})
    build_form_path(:edit_event_client_form_path, f, opts)
  end

  #private

  def display_info(field)
    @@name_info[field][:display]
  end

  def sort_info(field)
    @@name_info[field][:sort_key]
  end

  def display_name(field, value)
    field_names = display_info(field)
    field_names.has_key?(value) ? field_names[value] : value
  end

  def sort_key(field, value)
    sort_info(field)[value] + value
  end

  def build_form_path(method, form, opts) 
    opts[:client_id] = @client
    opts[:event_id] = @event
    send(method, form, opts)
  end
end
