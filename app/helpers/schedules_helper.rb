module SchedulesHelper
  def get_dates_volunteers(id, year, month, day)
    volunteers = Volunteer.joins(:schedules).where("vol_group_relationships.group_id" => id).where("schedules.when" => Date.new(year, month, day).strftime('%Y-%m-%d'))
    volunteers.map { |v| v.full_name }.join ','
  end
end
