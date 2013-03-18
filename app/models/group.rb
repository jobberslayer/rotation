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

  def current_volunteer?(vol)
    !vol_group_relationships.where('volunteer_id = ?', vol.id).first.disabled
  end

  def sign_up!(vol)
    r = vol_group_relationships.find_by_group_id(group.id)
    if r.nil?
      vol_group_relationships.create!(volunteer_id: vol.id, disabled: 'f')
    else
      r.disabled = 'f'
      r.save
    end
  end

  def signed_up?(vol)
    vol_group_relationships.find_by_volunteer_id(vol.id)
  end

  def sunday_volunteers
    (year, month, day) = DateHelp.get_next_sunday
    scheduled_volunteers(year, month, day)
  end

  def next_sunday_volunteers
    (year, month, day) = DateHelp.get_next_sunday
    (year, month, day) = DateHelp.next_week(year, month, day)
    scheduled_volunteers(year, month, day)
  end

  def scheduled_volunteers(year, month, day)
    Volunteer.scheduled_for(self.id, year, month, day)
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

  def active_volunteers
    volunteers.where('vol_group_relationships.disabled = ?', false)
  end

  def volunteers_changed_since(date)
    self.volunteers.where("vol_group_relationships.updated_at >= ?", date.strftime("%Y-%m-%d %H:%M:%S")) || []
  end 

end
