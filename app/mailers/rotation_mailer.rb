require 'erb'
class RotationMailer < ActionMailer::Base
  def test_email
    mail(
      to: EMAIL_TEST_ADDRESS, 
      from: EMAIL_FROM,
      subject: "test from the Rails Console", 
      body: "This is a test email"
    )
  end

  def group_email(group)
    email = EMAIL_TEST_ON ? EMAIL_TEST_ADDRESS : group.email
    (year, month, day) = DateHelp.get_next_sunday

    this_week = Formatters.date(year, month, day)
    this_week_vols = Formatters.volunteers(group.sunday_volunteers)
    (next_year, next_month, next_day) = DateHelp.next_week(year, month, day) 
    next_week = Formatters.date(next_year, next_month, next_day)
    next_week_vols = Formatters.volunteers(group.next_sunday_volunteers)

    body = ERB.new(group.email_body)

    mail(
      to: email, 
      from: EMAIL_FROM,
      subject: "#{group.name} rotation reminder", 
      body: body.result(binding) 
    )
  end

  def changes_email
    mail(
      to: EMAIL_ADMINS,
      from: EMAIL_FROM,
      subject: "Changes made to volunteers/groups.",
    )
  end
end
