class RenameTableVoljobToVolgroup < ActiveRecord::Migration
  def up
    rename_table :vol_job_relationships, :vol_group_relationships
  end

  def down
    rename_table :vol_group_relationships, :vol_job_relationships
  end
end
