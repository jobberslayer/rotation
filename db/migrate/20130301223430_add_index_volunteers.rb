class AddIndexVolunteers < ActiveRecord::Migration
  def change
    add_index "volunteers", ["first_name", "last_name", "email"], :unique => true
  end
end
