class VolGroupRelationship < ActiveRecord::Base
  attr_accessible :group_id, :volunteer_id

  belongs_to :volunteer, class_name: "Volunteer"
  belongs_to :group,     class_name: "Group"

  has_many :schedules, foreign_key: "relationship_id", dependent: :destroy
end
