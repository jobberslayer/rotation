class RenameFieldsInUsersToConformToRorThinking < ActiveRecord::Migration
  def change
    rename_column(:users, :fname, :first_name)     
    rename_column(:users, :lname, :last_name)     
    rename_column(:users, :uname, :user_name)     
  end
end
