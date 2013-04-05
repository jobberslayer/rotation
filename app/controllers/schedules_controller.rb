class SchedulesController < ApplicationController
  before_filter :signed_in_user

  def index
    (year, month, day) = DateHelp.get_next_sunday()
    redirect_to list_schedule_url(year, month, day)
  end

  def list
    @year = params[:year]
    @month = params[:month]
    @day = params[:day]

    @formal_date = Time.new(@year, @month, @day).strftime('%A, %B %d, %Y')

    (@prev_year, @prev_month, @prev_day) = DateHelp.previous_week(@year, @month, @day)
    (@next_year, @next_month, @next_day) = DateHelp.next_week(@year, @month, @day)

    @rotations = Group.available.where(rotation: true)
  end

  def edit
    @year = params[:year]
    @month = params[:month]
    @day = params[:day]
    @group_id = params[:group_id]
    @group = Group.find(@group_id)

    @formal_date = Time.new(@year, @month, @day).strftime('%A, %B %d, %Y')

    @volunteers = @group.active_volunteers
    @volunteers_serving = Volunteer.scheduled_for(@group_id, @year, @month, @day)
  end

  def update
    @year = params[:year]
    @month = params[:month]
    @day = params[:day]
    @group_id = params[:group_id]
    @group = Group.find(@group_id)

    @group.clear_schedule(@year, @month, @day)
    
    params[:volunteer_ids] ||= []
    params[:volunteer_ids].each do |vol_id|
      if Schedule.for_service(vol_id, @group_id, @year, @month, @day)
      else
        flash[:error] = s.errors.full_messages
        redirect_to edit(@year, @month, @day, @group_id)
      end
    end

    flash[:success] = "Active volunteers updated for #{@group.name}."
    redirect_to list_schedule_path(@year, @month, @day)
  end
end
