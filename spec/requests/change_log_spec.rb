require 'spec_helper'
include ApplicationHelper
include LastSync 

describe "ChangeLog" do
  describe "get while not logged in" do
    before { visit index_change_log_path }

    subject {page}

    it { should redirect_to_signin }
  end
end

describe "ChangeLog" do
  let!(:user) { FactoryGirl.create(:user) }

  before { sign_in user }

  context "looking at correct sync log for testing" do
    it { LAST_SYNC_FILE.should eq LAST_SYNC_TEST_FILE }
  end

  context "GET /change_logs" do
    before { visit index_change_log_path }
    subject { page }

    it { current_path.should eq index_change_log_path }
    it { find('title').text.should eq full_title('Change Log') }
    it { should have_selector('input', type: 'submit', name: 'commit', value: 'Resync') }
    it { should have_selector('h2', text: 'Resync') }
    it { should have_selector('h2', text: 'Mailing List Changes') }
    it { should have_selector('i', text: "since #{Formatters.date_time(LastSync.get)}") }
    it { find('a', text: 'Google Mailing List')[:href].should eq 'http://google.com/a/franklinstreetchurch.org' } 
    it { find('div#changes').text.strip.should eq '' }
  end

  context "with add changes" do
    let!(:group) { FactoryGirl.create(:group_with_volunteer) }
    let!(:volunteer) { group.volunteers.first }

    before { visit index_change_log_path }

    subject { page }

    it { find('div#changes/h3').text.should eq "#{group.name} <#{group.email}>" }  
    it { find('div#changes/ul/li/b').text.should eq "add" }  
    it { find('div#changes/ul/li').text.should include("#{volunteer.full_name} <#{volunteer.email}>") }  
  end

  context "with remove changes" do
    let!(:group) { FactoryGirl.create(:group_with_volunteer) }
    let!(:volunteer) { group.volunteers.first }

    before do 
      group.bench!(volunteer)
      visit index_change_log_path
    end

    subject { page }

    it { find('div#changes/h3').text.should eq "#{group.name} <#{group.email}>" }  
    it { find('div#changes/ul/li/b').text.should eq "remove" }  
    it { find('div#changes/ul/li').text.should include("#{volunteer.full_name} <#{volunteer.email}>") }  
  end

  context "resync" do
    let!(:group) { FactoryGirl.create(:group_with_volunteer) }
    let!(:volunteer) { group.volunteers.first }
    before { visit index_change_log_path }
    subject { page }

    it do
      #pause so time passes before page reloads
      sleep 1 
      find('div#changes/ul/li').text.should include("#{volunteer.full_name} <#{volunteer.email}>")
      last_sync = LastSync.get
      click_button "Resync"
      current_path.should eq index_change_log_path
      should have_success_message 'Resync complete'
      next_sync = LastSync.get
      next_sync.should > last_sync
      find('div#changes').text.strip.should eq ''
    end  
  end
end
