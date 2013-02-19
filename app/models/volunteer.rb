class Volunteer < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name

  before_save { |vol| vol.email = email.downcase }

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

  def full_name
    [first_name, last_name].join(' ')
  end

  def full_name=(name)
    self.last_name = name.split(' ').last
    self.first_name = name.split(' ')[0..-2].join(' ')
  end

end
