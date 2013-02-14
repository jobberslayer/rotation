# decided to make username consistent with fname and lname by renaming to uname
class ChangeUsernameToUname < ActiveRecord::Migration
  def change
    rename_column(:users, :username, :uname)
  end
end
