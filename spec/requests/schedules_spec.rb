require 'spec_helper'
include ApplicationHelper

describe "Schedules" do
  describe "get while not logged in" do
    before { visit index_schedule_path }
    it { page.should redirect_to_signin }
  end
end
describe "Schedules" do
  describe "GET /schedules" do
    let!(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit index_schedule_path
    end

    subject { page }
    it "should redirect to this coming Sunday" do
      current_path.should eq list_schedule_path(*DateHelp.get_next_sunday)
      find('title').text.should eq full_title("Schedules")
      find('h2').text.should eq Formatters.formal_date(*DateHelp.get_next_sunday)
    end
  end
end
