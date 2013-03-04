class GroupsController < ApplicationController
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

  def pager
    Group.paginate(page: params[:page], per_page: 10)
  end
end
