# add index to uname to keep it unique
class AddIndexToUsersUname < ActiveRecord::Migration
  def change
    add_index :users, :uname, unique: true
  end
end
