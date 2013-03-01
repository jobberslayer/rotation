class Volunteer < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name

  before_save { |vol| vol.email = email.downcase }

  has_many :vol_group_relationships, foreign_key: "volunteer_id", dependent: :destroy
  has_many :groups, through: :vol_group_relationships, source: :group

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :first_name, 
        presence: true, 
        length: {maximum: 50}
  validates :last_name, 
        presence: true, 
        length: {maximum: 50}
  validates :email, 
        presence: true, 
        length: {maximum: 50}, 
        format: { with: VALID_EMAIL_REGEX }
  validates_uniqueness_of :first_name, :scope => [:last_name, :email]
  validates_uniqueness_of :last_name, :scope => [:first_name, :email]
  validates_uniqueness_of :email, :scope => [:last_name, :first_name]

  def full_name
    [first_name, last_name].join(' ')
  end

  def full_name=(name)
    self.last_name = name.split(' ').last
    self.first_name = name.split(' ')[0..-2].join(' ')
  end

  def joined!(group)
    vol_group_relationships.create!(group_id: group.id)
  end

  def joined?(group)
    vol_group_relationships.find_by_group_id(group.id)
  end

end
