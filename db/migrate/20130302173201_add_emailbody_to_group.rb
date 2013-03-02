class AddEmailbodyToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :email_body, :string
  end
end
