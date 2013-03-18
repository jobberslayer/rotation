class AddColumnDisabledToVolGroupRelationships < ActiveRecord::Migration
  def change
    add_column :vol_group_relationships, :disabled, :boolean 
  end
end
