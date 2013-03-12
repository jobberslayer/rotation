class ChangeRelationshipToRelationshipidForSchedule < ActiveRecord::Migration
  def change
    rename_column(:schedules, :relationship, :relationship_id)
  end
end
