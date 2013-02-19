class CreateVolJobRelationships < ActiveRecord::Migration
  def change
    create_table :vol_job_relationships do |t|
      t.integer :volunteer_id
      t.integer :job_id

      t.timestamps
    end

    add_index :vol_job_relationships, :volunteer_id
    add_index :vol_job_relationships, :job_id
    add_index :vol_job_relationships, [:volunteer_id, :job_id], unique: true
  end
end
