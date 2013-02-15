class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_uname(params[:session][:uname].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_to root_url
    else
      flash.now[:error] = 'Invalid user name/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end

end
