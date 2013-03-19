class ChangeLogController < ApplicationController
  before_filter :signed_in_user

  def index
    @groups = Group.available
    @last_sync = LastSync.get
  end

  def resync
    flash[:success] = "Resync complete"
    LastSync.set
    redirect_to index_change_log_path
  end
end
