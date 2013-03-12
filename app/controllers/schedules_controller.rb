class SchedulesController < ApplicationController
  def index
    (year, month, day) = get_next_sunday()
    redirect_to list_schedule_url(year, month, day)
  end

  def list
    @year = params[:year]
    @month = params[:month]
    @day = params[:day]

    @formal_date = Time.new(@year, @month, @day).strftime('%A, %B %d, %Y')

    (@prev_year, @prev_month, @prev_day) = previous_week(@year, @month, @day)
    (@next_year, @next_month, @next_day) = next_week(@year, @month, @day)

    @rotations = Group.where(rotation: true)
  end

  def get_next_sunday
    d = Time.now.end_of_week.to_a
    return [d[5], sprintf('%02d', d[4]), sprintf('%02d', d[3])]
  end

  def previous_week(year, month, day)
    d = 1.week.ago(Time.new(year, month, day)).to_a
    return [d[5], sprintf('%02d', d[4]), sprintf('%02d', d[3])]
  end

  def next_week(year, month, day)
    d = -1.week.ago(Time.new(year, month, day)).to_a
    return [d[5], sprintf('%02d', d[4]), sprintf('%02d', d[3])]
  end

end
