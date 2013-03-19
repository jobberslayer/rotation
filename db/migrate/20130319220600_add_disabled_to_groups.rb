class AddDisabledToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :disabled, :boolean, default: false
  end
end
