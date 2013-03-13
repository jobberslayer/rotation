module SchedulesHelper
  def get_dates_volunteers(id, year, month, day)
    volunteers = Volunteer.scheduled_for(id, year, month, day)
    volunteers.map { |v| v.full_name }.join ','
  end
end
