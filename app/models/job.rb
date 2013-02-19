class Job < ActiveRecord::Base
  attr_accessible :email, :name

  before_save { |job| job.email = email.downcase }

  has_many :vol_job_relationships, foreign_key: "job_id", dependent: :destroy
  has_many :volunteers, through: :vol_job_relationships, source: :volunteer

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, 
        presence: true, 
        length: {maximum: 50}
  validates :email, 
        presence: true, 
        length: {maximum: 50}, 
        format: { with: VALID_EMAIL_REGEX }

  def volunteered!(vol)
    vol_job_relationships.create!(volunteer_id: vol.id)
  end

  def volunteered?(vol)
    vol_job_relationships.find_by_volunteer_id(vol.id)
  end
end
