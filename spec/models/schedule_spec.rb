require 'spec_helper'

describe Schedule do
  describe "for service by id" do
    let(:group) { FactoryGirl.create(:group) }
    let(:volunteer) { FactoryGirl.create(:volunteer) }

    before do
      year, month, day = DateHelp.today
      group.volunteers << volunteer
      Schedule.for_service_by_id(volunteer.id, group.id, year, month, day)
    end

    let(:scheduled_vols) { group.scheduled_volunteers(*DateHelp.today) }

    it { scheduled_vols.first.id.should eq volunteer.id }
  end
  describe "for service" do
    let(:group) { FactoryGirl.create(:group) }
    let(:volunteer) { FactoryGirl.create(:volunteer) }

    before do
      year, month, day = DateHelp.today
      group.volunteers << volunteer
      Schedule.for_service(volunteer, group, year, month, day)
    end

    let(:scheduled_vols) { group.scheduled_volunteers(*DateHelp.today) }

    it { scheduled_vols.first.id.should eq volunteer.id }
  end
end
