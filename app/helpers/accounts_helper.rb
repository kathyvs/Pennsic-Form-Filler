module AccountsHelper
  def role_checkboxes(roles, account)
    roles.sort_by(&:name).map do |role|
      name = "roles[#{role.id}]"
      [check_box_tag(name, 1, account.roles.include?(role)), 
       label_tag(name, role.name.titleize)]
    end
  end
  
  def can_edit_account?(to_edit)
    @account == to_edit || @account.can_modify_other_accounts?
  end
end
