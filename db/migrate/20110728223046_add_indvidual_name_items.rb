class AddIndvidualNameItems < ActiveRecord::Migration
  def self.up
    remove_column :forms, :action_sub_type
    add_column :forms, :action_type_other, :string
    add_column :forms, :action_change_type, :string
    add_column :forms, :resub_from, :string
    add_column :forms, :submission_type, :string
    add_column :forms, :submission_type_other, :string
    add_column :forms, :submitted_name, :string
    add_column :forms, :documentation, :string
    add_column :forms, :doc_pdf, :binary, :limit => 5.megabyte
    add_column :forms, :date_submitted, :date
    add_column :forms, :needs_review, :boolean
    add_column :forms, :authentic_text, :string
    add_column :forms, :authentic_flags, :string
    add_column :forms, :no_changes_minor_flag, :boolean
    add_column :forms, :no_changes_major_flag, :boolean
    add_column :forms, :preferred_changes_type, :string
    add_column :forms, :preferred_changes_text, :string
    add_column :forms, :no_holding_name_flag, :boolean
    add_column :forms, :previous_kingdom, :string
    add_column :forms, :previous_name, :string
    add_column :forms, :original_returned, :string
    add_column :forms, :gender_name, :string
  end

  def self.down
    add_column :forms, :action_sub_type, :string
    remove_column :forms, :action_type_other, :action_change_type
    remove_column :forms, :resub_from
    remove_column :forms, :submission_type, :submission_type_other
    remove_column :forms, :submitted_name
    remove_column :forms, :documentation, :doc_pdf
    remove_column :forms, :date_submitted, :needs_review
    remove_column :forms, :authentic_text, :authentic_flags
    remove_column :forms, :no_changes_minor_flag, :no_changes_major_flag
    remove_column :forms, :preferred_changes_type, :preferred_changes_text
    remove_column :forms, :no_holding_name_flag
    remove_column :forms, :previous_kingdom, :previous_name, :original_returned
    remove_column :forms, :gender_name
  end
end
