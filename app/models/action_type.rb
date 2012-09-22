
class ActionType

  attr_reader :display, :values

  def initialize(display, is_new, values = {})
    @display = display
    @is_new = is_new
    @values = values
  end

  def self.simple(display)
    ActionType.new(display, true, :action_type => display)
  end

  def new_to_kingdom?
    @is_new
  end
  
  def matches(form)
    values.to_a.all? do |prop, value|
      form.send(prop) == value
    end
  end

  def set_values(form)
    values.each_pair do |prop, value|
      method = "#{prop}=".to_sym
      form.send(method, value)
    end
  end

  def with_display(display)
    ActionType.new(display, true, self.values)
  end

  NEW = ActionType.simple('New')
  RESUB_KINGDOM = ActionType.new("Resubmission (Kingdom)", false,
                                 :action_type => 'Resubmission',
                                 :resub_from => 'Kingdom')
  RESUB_LAUREL = ActionType.new("Resubmission (Laurel)", false,
                                :action_type => 'Resubmission',
                                :resub_from => 'Laurel')
  CHANGE_RETAIN = ActionType.new("Change", true,
                                 :action_type => 'Change',
                                 :action_change_type => 'Retain')
  CHANGE_RELEASE = ActionType.new('Change', true,
                                  :action_type => 'Change',
                                  :action_change_type => 'Release')
  NAME_CHANGE_HOLDING = ActionType.new("Name change from holding name", false,
                                       :action_type => 'Holding')
  APPEAL = ActionType.simple('Appeal')
  OTHER = ActionType.simple('Other')

end

