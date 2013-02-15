class User < ActiveRecord::Base
  attr_accessible :email, :fname, :lname, :uname, :password, :password_confirmation
  has_secure_password

  before_save { |user| user.email = email.downcase }
  before_save { |user| user.uname = uname.downcase }
  before_save :create_remember_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :fname, 
        presence: true, 
        length: {maximum: 50}
  validates :lname, 
        presence: true, 
        length: {maximum: 50}
  validates :uname, 
        presence: true, 
        length: {maximum: 50},
        uniqueness: { case_sensitive: false }
  validates :email, 
        presence: true, 
        length: {maximum: 50}, 
        format: { with: VALID_EMAIL_REGEX }
  validates :password, 
        presence: true, 
        length: { minimum: 6 }
  validates :password_confirmation, 
        presence: true

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
