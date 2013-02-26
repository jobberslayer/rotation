require 'spec_helper'

describe VolJobRelationship do
  let(:vol) { FactoryGirl.create(:volunteer) }
  let(:job) { FactoryGirl.create(:job) }
  let(:relationship) {vol.vol_job_relationships.build(job_id: job.id) }

  subject { relationship }

  it { should be_valid }

  describe "accessible attributes" do 
    it "should not allow access to volunteer_id" do
      expect do
        VolJobRelationship.new(volunteer_id: vol.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

end
