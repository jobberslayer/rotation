class VolGroupRelationship < ActiveRecord::Base
  attr_accessible :group_id, :volunteer_id

  belongs_to :volunteer, class_name: "Volunteer"
  belongs_to :group,     class_name: "Group"

  has_many :schedules, foreign_key: "relationship_id", dependent: :destroy

  def scheduled?(year, month, day)
    vgr = VolGroupRelationship.
        joins(:schedules).
        where(id: self.id).
        where("schedules.when" => 
            Date.new(year.to_i, month.to_i, day.to_i).strftime('%Y-%m-%d')) 
    !vgr.empty?
  end
end
