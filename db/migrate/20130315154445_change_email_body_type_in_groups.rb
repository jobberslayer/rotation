class ChangeEmailBodyTypeInGroups < ActiveRecord::Migration
  def up
    change_column :groups, :email_body, :text
  end

  def down
    change_column :groups, :email_body, :string
  end
end
