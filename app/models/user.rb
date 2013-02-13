class User < ActiveRecord::Base
  attr_accessible :email, :fname, :lname, :uname

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :fname, presence: true, length: {maximum: 50}
  validates :lname, presence: true, length: {maximum: 50}
  validates :uname, presence: true, length: {maximum: 50}
  validates :email, presence: true, length: {maximum: 50}, format: { with: VALID_EMAIL_REGEX }
end
