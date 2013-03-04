class Group < ActiveRecord::Base
  attr_accessible :email, :name, :email_body, :rotation

  before_save { |group| group.email = email.downcase }

  has_many :vol_group_relationships, foreign_key: "group_id", dependent: :destroy
  has_many :volunteers, through: :vol_groups_relationships, source: :volunteer

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
end
