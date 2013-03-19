class AddDisabledColToVolunteers < ActiveRecord::Migration
  def change
    add_column :volunteers, :disabled, :boolean
  end
end
