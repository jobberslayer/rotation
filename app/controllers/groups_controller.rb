class GroupsController < ApplicationController
  before_filter :signed_in_user
  
  def create
    @g = Group.find_by_name_and_disabled(params[:group][:name], true)
    if @g.nil?
      @g = Group.new(params[:group])
    else
      @g.email = params[:group][:email]
      @g.disabled = false
    end

    if @g.save
      flash.now[:success] = "Group #{@g.name} created."
      @group = Group.new()
    else
      @group = @g
    end

    @groups = pager()
    render "index"
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    if @group.update_attributes(params[:group])
      flash.now[:success] = "Group #{@group.name} updated."
      @group = Group.new()
      @groups = pager()
      render "index"
    else
      render "edit"
    end
  end

  def destroy
    g = Group.find(params[:id])
    g.disable
    flash[:success] = "Group #{g.name} removed."
    redirect_to groups_url
  end

  def index
    @group = Group.new()
    @groups = pager()
  end

  def volunteers
    @group = Group.find(params[:id])
    @volunteers = @group.active_volunteers
    @unjoined = @group.non_volunteers()
  end

  def remove_volunteer
    relationship = VolGroupRelationship.find_by_volunteer_id_and_group_id(
      params[:volunteer_id], 
      params[:group_id]
    )
    relationship.disabled = true
    relationship.save
    redirect_to volunteers_group_url(params[:group_id])
  end

  def add_volunteer
    vol = Volunteer.find(params[:volunteer_id])
    group = Group.find(params[:group_id])
    vol.join!(group)    
    redirect_to volunteers_group_url(group.id)
  end

  def export
    @group = Group.find(params[:id])
  end

  def test_email
    @group = Group.find(params[:id])
    RotationMailer.send_group_email(@group, current_user.email).deliver
    flash[:success] = "Test email sent to #{current_user.email}."
    redirect_to groups_path
  end

  def pager
    Group.available.paginate(page: params[:page], per_page: 20)
  end
end
