class VolGroupRelationship < ActiveRecord::Base
  attr_accessible :group_id, :volunteer_id

  belongs_to :volunteer, class_name: "Volunteer"
  belongs_to :group,     class_name: "Group"
end
