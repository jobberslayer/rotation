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

  def edit
    @year = params[:year]
    @month = params[:month]
    @day = params[:day]
    @group_id = params[:group_id]
    @group = Group.find(@group_id)

    @formal_date = Time.new(@year, @month, @day).strftime('%A, %B %d, %Y')

    @volunteers = @group.volunteers
    @volunteers_serving = Volunteer.scheduled_for(@group_id, @year, @month, @day)
  end

  def update
    @year = params[:year]
    @month = params[:month]
    @day = params[:day]
    @group_id = params[:group_id]
    @group = Group.find(@group_id)

    @volunteers_serving = Volunteer.scheduled_for(@group_id, @year, @month, @day)
    
    @group.clear_schedule(@year, @month, @day)
    
    params[:volunteer_ids] ||= []
    params[:volunteer_ids].each do |vol_id|
      r = VolGroupRelationship.find_by_volunteer_id_and_group_id(vol_id, @group_id)
      s = Schedule.new()
      s.relationship_id = r.id
      s.when = "#{@year}-#{@month}-#{@day}"
      if s.save
      else
        flash[:error] = s.errors.full_messages
        redirect_to edit(@year, @month, @day, @group_id)
      end
    end

    flash[:success] = "Active volunteers updated for #{@group.name}."
    redirect_to list_schedule_path(@year, @month, @day)
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
