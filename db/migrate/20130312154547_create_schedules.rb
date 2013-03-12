class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.integer :relationship
      t.date :when

      t.timestamps
    end
  end
end
