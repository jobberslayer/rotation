class RenameTableJobsToGroups < ActiveRecord::Migration
  def up
    rename_table :jobs, :groups
  end

  def down
    rename_table :groups, :jobs
  end
end
