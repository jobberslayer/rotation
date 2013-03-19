class RenameIndexs64CharRule < ActiveRecord::Migration
  def up
    remove_index :volunteers, :name => :index_volunteers_on_first_name_and_last_name_and_email
    add_index :volunteers, [:first_name, :last_name, :email], :name => :index_volunteers_compound_key, :unique => true
  end

  def down
  end
end
