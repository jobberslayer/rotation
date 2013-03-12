class Schedule < ActiveRecord::Base
  attr_accessible :relationship_id, :when

  belongs_to :vol_group_relationship, class_name: "VolGroupRelationship"
end
