class ChangeHasrotationToRotationInGroups < ActiveRecord::Migration
  def up
    rename_column :groups, :has_rotation, :rotation
  end

  def down
    rename_column :groups, :roation, :has_rotation
  end
end
