class VolGroupRelationship < ActiveRecord::Base
  attr_accessible :group_id, :volunteer_id, :disabled

  belongs_to :volunteer, class_name: "Volunteer"
  belongs_to :group,     class_name: "Group"

  has_many :schedules, foreign_key: "relationship_id", dependent: :destroy

  scope :active, where('disabled != ?', true)

end
