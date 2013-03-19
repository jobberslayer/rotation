class SetDefaultForDisabledVolGroupRelationships < ActiveRecord::Migration
  def up
    change_column :vol_group_relationships, :disabled, :boolean, default: false
  end

  def down
  end
end
