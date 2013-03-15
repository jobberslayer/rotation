class RotationMailer < ActionMailer::Base
  def test_email
    mail(:to => "kevin@e-kevin.com", :from => "mailing.list.admin@franklinstreetchurch.org",:subject => "test from the Rails Console", body: "This is a test email")
  end
end
