class Schedule < ActiveRecord::Base
  attr_accessible :relationship_id, :when

  belongs_to :vol_group_relationship, class_name: "VolGroupRelationship"

  def self.for_service_by_id(volunteer, group, year, month, day)
    self.for_service_by_id(volunteer.id, group.id, year, month, day)
  end

  def self.for_service_by_id(vol_id, group_id, year, month, day)
    r = VolGroupRelationship.find_by_volunteer_id_and_group_id(vol_id, group_id)
    s = Schedule.new()
    s.relationship_id = r.id
    s.when = "#{year}-#{month}-#{day}"
    s.save
  end
end
