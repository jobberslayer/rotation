class AddRotationColToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :has_rotation, :boolean
  end
end
