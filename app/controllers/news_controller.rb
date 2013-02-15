class NewsController < ApplicationController
  include SessionsHelper 
  
  before_filter :signed_in_user

  def index
  end

end
