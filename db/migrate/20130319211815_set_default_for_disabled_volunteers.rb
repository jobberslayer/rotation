class SetDefaultForDisabledVolunteers < ActiveRecord::Migration
  def up
    change_column :volunteers, :disabled, :boolean, default: false
  end

  def down
  end
end
