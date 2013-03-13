class Group < ActiveRecord::Base
  attr_accessible :email, :name, :email_body, :rotation

  before_save { |group| group.email = email.downcase }

  has_many :vol_group_relationships, foreign_key: "group_id", dependent: :destroy
  has_many :volunteers, through: :vol_group_relationships, source: :volunteer
  has_many :schedules, through: :vol_group_relationships, source: :schedules

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i  

  validates :name, 
        presence: true, 
        length: {maximum: 50}
  validates :email, 
        presence: true, 
        length: {maximum: 50}, 
        format: { with: VALID_EMAIL_REGEX }

  default_scope order('name')

  def signed_up!(vol)
    vol_group_relationships.create!(volunteer_id: vol.id)
  end

  def signed_up?(vol)
    vol_group_relationships.find_by_volunteer_id(vol.id)
  end

  def non_volunteers
    Volunteer.all - self.volunteers
  end

  def clear_schedule(year, month, day)
    vgrs = VolGroupRelationship.joins(:schedules).where("vol_group_relationships.group_id" => self.id).where("schedules.when" => Date.new(year.to_i, month.to_i, day.to_i).strftime('%Y-%m-%d'))
    vgrs.each do |relationship|
      Schedule.delete_all(["relationship_id = ?", relationship.id])
    end
  end
end
