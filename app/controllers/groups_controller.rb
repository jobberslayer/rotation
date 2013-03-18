class GroupsController < ApplicationController
  before_filter :signed_in_user
  
  def create
    @g = Group.new(params[:group])
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
    g.destroy
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
    relationship.destroy
    redirect_to volunteers_group_url(params[:group_id])
  end

  def add_volunteer
    vol = Volunteer.find(params[:volunteer_id])
    group = Group.find(params[:group_id])
    vol.join!(group)    
    redirect_to volunteers_group_url(group.id)
  end

  def pager
    Group.paginate(page: params[:page], per_page: 10)
  end
end
