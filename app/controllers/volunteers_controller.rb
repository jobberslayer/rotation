class VolunteersController < ApplicationController
  before_filter :signed_in_user

  def create
    # in case already in database but disabled in the past
    @vol = Volunteer.find_by_first_name_and_last_name_and_email_and_disabled(params[:volunteer][:first_name], params[:volunteer][:last_name], params[:volunteer][:email], true)
    if @vol.nil?
      @vol = Volunteer.new(params[:volunteer])
    else
      @vol.disabled = false
    end

    if @vol.save
      flash.now[:success] = "Volunteer #{@vol.full_name} created."
      @volunteer = Volunteer.new()
    else
      @volunteer = @vol
    end

    @volunteers = pager()
    render "index"
  end

  def edit
    @volunteer = Volunteer.find(params[:id])
  end

  def update
    @volunteer = Volunteer.find(params[:id])
    if @volunteer.update_attributes(params[:volunteer])
      flash[:success] = "Volunteer #{@volunteer.full_name} updated."
      @volunteer = Volunteer.new()
      @volunteers = pager()
      render "index"
    else
      render "edit"
    end
  end

  def destroy
    vol = Volunteer.find(params[:id])
    vol.disable
    flash[:success] = "#{vol.full_name} removed."
    redirect_to volunteers_url
  end

  def index
    @volunteer = Volunteer.new()
    @volunteers = pager()
  end

  def groups
    @volunteer = Volunteer.find(params[:id])
    @groups = @volunteer.active_groups
    @unjoined = @volunteer.not_joined()
  end

  def leave_group
    relationship = VolGroupRelationship.find_by_volunteer_id_and_group_id(
      params[:volunteer_id], 
      params[:group_id]
    )
    relationship.disabled = true
    relationship.save
    redirect_to groups_volunteer_url(params[:volunteer_id])
  end

  def join_group
    vol = Volunteer.find(params[:volunteer_id])
    group = Group.find(params[:group_id])
    vol.join!(group)    
    redirect_to groups_volunteer_url(vol.id)
  end

  def pager
    Volunteer.available.search(params[:search]).paginate(page: params[:page], per_page: 10)
  end
end
