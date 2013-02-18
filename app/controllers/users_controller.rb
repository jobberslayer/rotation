class UsersController < ApplicationController
  before_filter :signed_in_user

  def edit
    @user = User.find(current_user.id)
  end

  def update
    @user = User.find(current_user.id)
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      sign_in @user
      redirect_to root_path
    else
      render "edit"
    end
  end
end
