
class ActionType

  attr_reader :display, :values

  def initialize(display, values = {})
    @display = display
    @values = values
  end

  def self.simple(display)
    ActionType.new(display, :action_type => display)
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
    ActionType.new(display, self.values)
  end

  NEW = ActionType.simple('New')
  RESUB_KINGDOM = ActionType.new("Resubmission (Kingdom)", 
                                 :action_type => 'Resubmission',
                                 :resub_from => 'Kingdom')
  RESUB_LAUREL = ActionType.new("Resubmission (Laurel)",
                                :action_type => 'Resubmission',
                                :resub_from => 'Laurel')
  CHANGE_RETAIN = ActionType.new("Change",
                                 :action_type => 'Change',
                                 :action_change_type => 'Retain')
  CHANGE_RELEASE = ActionType.new('Change',
                                  :action_type => 'Change',
                                  :action_change_type => 'Release')
  NAME_CHANGE_HOLDING = ActionType.new("Name change from holding name",
                                       :action_type => 'Holding')
  APPEAL = ActionType.simple('Appeal')
  OTHER = ActionType.simple('Other')

end

