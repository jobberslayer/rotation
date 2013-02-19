class VolJobRelationship < ActiveRecord::Base
  attr_accessible :job_id, :volunteer_id

  belongs_to :volunteer, class_name: "Volunteer"
  belongs_to :job,       class_name: "Job"
end
