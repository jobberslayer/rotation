class RenameColumnVolgrouprelationshipsJobidToGroupid < ActiveRecord::Migration
  def up
    rename_column :vol_group_relationships, :job_id, :group_id
  end

  def down
    rename_column :vol_group_relationships, :group_id, :job_id
  end
end
