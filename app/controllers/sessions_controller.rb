class SessionsController < ApplicationController
  before_filter :signed_in_user

  def new
  end

  def create
    user = User.find_by_user_name(params[:session][:user_name].downcase)
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

  private
    def signed_in_user
      redirect_to root_url, notice: "Already signed in." if signed_in?
    end

end
