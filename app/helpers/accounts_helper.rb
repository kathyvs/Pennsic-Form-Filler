module AccountsHelper
  include ActiveSupport::Inflector
  def role_checkboxes(account)
    Role.all.sort_by(&:name).map do |role|
      [check_box_tag('roles', role.id, account.roles.include?(role)), 
       label_tag('roles', titleize(role.name))]
    end
  end
end
