module AccountsHelper
  include ActiveSupport::Inflector
  def role_checkboxes(roles, account)
    roles.sort_by(&:name).map do |role|
      [check_box_tag('roles', role.id, account.roles.include?(role)), 
       titleize(role.name)]
    end
  end
end
