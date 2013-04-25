require 'spec_helper'
include ApplicationHelper

describe "Volunteers" do
  describe "get while not logged in" do
    before { visit volunteers_url }
    it { page.should redirect_to_signin }
  end
end

describe "Volunteers" do

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }  

  describe "root" do
    before { visit volunteers_url }

    subject {page}
    it { should_not redirect_to_signin }
    it { subject.status_code.should be(200) }
    it { find('title').text.should eq full_title('Volunteers') }

    context "add form" do
      it { should have_selector('#volunteer_first_name') }
      it { should have_selector('#volunteer_last_name') }
      it { should have_selector('#volunteer_email') }
      it { should have_selector('input', type: 'submit', name: 'commit', value: 'Add Volunteer') }
    end

    context "with no volunteers" do
      it { should have_selector('table tr', count: 2) }
      it { find('table/tr[1]/th[1]').text.should eq 'Name' }
      it { find('table/tr[1]/th[2]').text.should eq 'Email' }
      it { find('table/tr[1]/th[3]').text.should eq '' }
      it { find('table/tr[1]/th[4]').text.should eq '' }
      it { find('table/tr[1]/th[5]').text.should eq '' }
      it { should have_no_selector('table/tr[1]/th[6]')}
      it { find('table/tr[2]/td[1]').text.should eq 'No Volunteers' }
    end

    context "with a volunteer" do
      let!(:volunteer) { FactoryGirl.create(:volunteer) }
      before do 
        visit volunteers_url
      end

      subject {page}
      it { should have_selector('table tr', count: 2) }

      it { find('table/tr[1]/th[1]').text.should eq 'Name' }
      it { find('table/tr[1]/th[2]').text.should eq 'Email' }
      it { find('table/tr[1]/th[3]').text.should eq '' }
      it { find('table/tr[1]/th[4]').text.should eq '' }
      it { find('table/tr[1]/th[5]').text.should eq '' }
      it { should have_no_selector('table/tr[1]/th[6]')}

      it { find('table/tr[2]/td[1]').text.should eq volunteer.full_name }
      it { find('table/tr[2]/td[2]').text.should eq volunteer.email}
      it { find('table/tr[2]/td[3]').text.should eq 'edit'}
      it { find('table/tr[2]/td[4]').text.should eq 'groups'}
      it { find('table/tr[2]/td[5]').text.strip.should eq 'remove'}
      it { should have_no_selector('table/tr[2]/th[6]')}
    end
  end

  describe "editing volunteer page" do
    let!(:volunteer) { FactoryGirl.create(:volunteer) }
    before { visit volunteers_url }

    it "click edit" do
      edit_link = find('table/tr[2]/td[3]/a')
      edit_link[:href].should eq edit_volunteer_path(volunteer.id)
      edit_link.click
      current_path.should eq edit_volunteer_path(volunteer.id)
      find('title').text.should eq full_title('Edit Volunteer')
      page.should have_selector('#volunteer_first_name')
      page.should have_selector('#volunteer_last_name')
      page.should_not have_selector('#volunteer_email')
      page.should have_selector('input', type: 'submit', name: 'commit', value: 'Save Changes')
    end
  end

  describe "editing volunteer" do
    let!(:volunteer) { FactoryGirl.create(:volunteer) }
    before { visit edit_volunteer_url(volunteer.id) }

    it "save edit" do
      fill_in "First name", with: "#{volunteer.first_name}_changed" 
      fill_in "Last name", with: "#{volunteer.last_name}_changed"
      click_button 'Save changes' 

      find('title').text.should eq full_title('Volunteers')
      changed_vol = Volunteer.find(volunteer.id)
      changed_vol.first_name = "#{volunteer.first_name}_changed"
      changed_vol.last_name = "#{volunteer.last_name}_changed"
      page.should have_success_message "Volunteer #{changed_vol.full_name} updated."
      page.find('table/tr[2]/td[1]').text.should eq changed_vol.full_name 
    end
  end

  describe "group relationships page" do
    let!(:volunteer) { FactoryGirl.create(:volunteer_with_group) }
    let!(:group_not_in) { FactoryGirl.create(:group) }
    before do
      visit volunteers_url
    end

    it "click groups" do
      groups_link = find('table/tr[2]/td[4]/a')
      groups_link[:href].should eq groups_volunteer_path(volunteer.id)
      groups_link.click
      current_path.should eq groups_volunteer_path(volunteer.id)
      find('title').text.should eq full_title('Volunteer Groups')
      find('h1').text.should eq "#{volunteer.full_name} <#{volunteer.email}>"
      page.should have_selector('h3', text: 'Current Groups')
      page.should have_selector('h3', text: 'Available Groups')

      find('#current_groups/table/tr[1]/th[1]').text.should eq 'Name'
      find('#current_groups/table/tr[1]/th[2]').text.should eq 'Email'
      find('#current_groups/table/tr[1]/th[3]').text.should eq ''
      find('#current_groups/table/tr[1]/th[3]').text.should eq ''
      page.should have_no_selector('#current_groups/table/tr[1]/th[4]')

      find('#current_groups/table/tr[2]/td[1]').text.should eq volunteer.groups.first.name
      find('#current_groups/table/tr[2]/td[2]').text.should eq volunteer.groups.first.email
      find('#current_groups/table/tr[2]/td[3]').text.should eq 'leave'

      find('#available_groups/table/tr[1]/th[1]').text.should eq 'Name'
      find('#available_groups/table/tr[1]/th[2]').text.should eq 'Email'
      find('#available_groups/table/tr[1]/th[3]').text.should eq ''
      find('#available_groups/table/tr[1]/th[3]').text.should eq ''
      page.should have_no_selector('#available_groups/table/tr[1]/th[4]')

      find('#available_groups/table/tr[2]/td[1]').text.should eq group_not_in.name
      find('#available_groups/table/tr[2]/td[2]').text.should eq group_not_in.email
      find('#available_groups/table/tr[2]/td[3]').text.should eq 'add'
    end
  end

  describe "adding a group" do
    let!(:volunteer) { FactoryGirl.create(:volunteer_with_group) }
    let!(:group_not_in) { FactoryGirl.create(:group) } 

    before { visit groups_volunteer_path(volunteer.id) }

    it "join group" do
      add_link = find('#available_groups/table/tr[2]/td[3]/a')
      add_link.text.should eq 'add'
      add_link[:href].should eq join_group_volunteer_path(volunteer.id, group_not_in.id)
      volunteer.active_groups.should_not include(group_not_in)
      add_link.click
      page.should have_success_message "#{volunteer.full_name} added to #{group_not_in.name}."
      updated_vol = Volunteer.find(volunteer.id)
      updated_vol.active_groups.should include(group_not_in)
      page.should have_selector('#current_groups table tr', count: 3)
      page.should have_selector('#available_groups table tr', count: 1)
    end
  end

  describe "leaving a group" do
    let!(:volunteer) { FactoryGirl.create(:volunteer_with_group) }
    let!(:group) { volunteer.groups.first }

    before { visit groups_volunteer_path(volunteer.id) }
    
    it "leave group" do
      leave_link = find('#current_groups/table/tr[2]/td[3]/a')
      leave_link.text.should eq 'leave'
      leave_link[:href].should eq leave_group_volunteer_path(volunteer.id, group)
      leave_link.click
      page.should have_success_message "#{volunteer.full_name} removed from #{group.name}"
      updated_vol = Volunteer.find(volunteer.id)
      updated_vol.active_groups.should_not include(group)
      page.should have_selector('#current_groups table tr', count: 1)
      page.should have_selector('#available_groups table tr', count: 2)
    end

  end

  describe "removing volunteer" do
    let!(:volunteer) { FactoryGirl.create(:volunteer) }
    before { visit volunteers_url }

    it "click remove" do
      remove_link = find('table/tr[2]/td[5]/a')
      remove_link[:href].should eq volunteer_path(volunteer.id)
      remove_link['data-method'].should eq 'delete'
      remove_link.click
      Volunteer.find(volunteer.id).should be_disabled
      find('table/tr[2]/td[1]').text.should eq 'No Volunteers'
      page.should have_success_message "#{volunteer.full_name} removed."
    end
  end

  describe "add volunteer" do
    before { visit volunteers_url }

    it "with empty data" do
      click_button 'Add Volunteer'
      page.should have_error_message "See errors below."
      page.should have_error_message "First name can't be blank"
      page.should have_error_message "Last name can't be blank"
      page.should have_error_message "Email can't be blank"
      page.should have_error_message "Email is invalid"
    end

    it "with bad email" do
      fill_in 'First name', with: 'Testy'
      fill_in 'Last name', with: 'McTester'
      fill_in 'Email', with: 'tmctester@example.'
      click_button 'Add Volunteer'
      page.should have_error_message "See errors below."
      page.should have_error_message "Email is invalid"
    end

    it "with valid data" do
      fill_in 'First name', with: 'Testy'
      fill_in 'Last name', with: 'McTester'
      fill_in 'Email', with: 'tmctester@example.com'
      click_button 'Add Volunteer'
      page.should have_success_message "Volunteer Testy McTester created."
      vol = Volunteer.find_by_email('tmctester@example.com')
      find('table/tr[2]/td[1]').text.should eq vol.full_name 
    end
  end
  
  describe "search without javascript" do
    let!(:vol_aaa) { FactoryGirl.create(:volunteer, last_name: 'Aaa') }
    let!(:vol_zzz) { FactoryGirl.create(:volunteer, last_name: 'Zzz') }

    before { visit volunteers_url }
    subject { page }

    it { should have_selector('table/tr', count: 3) }
    it { find('table/tr[2]/td[1]').text.should eq vol_aaa.full_name }
    it { find('table/tr[3]/td[1]').text.should eq vol_zzz.full_name }
    it "submit form"  do
      fill_in 'search', with: 'zzz'
      click_button 'Search'
      should have_selector('table/tr', count: 2)
      find('table/tr[2]/td[1]').text.should eq vol_zzz.full_name 
    end
  end

  describe "search with javascript", js: true do
    let!(:vol_aaa) { FactoryGirl.create(:volunteer, last_name: 'Aaa') }
    let!(:vol_zzz) { FactoryGirl.create(:volunteer, last_name: 'Zzz') }

    before { visit volunteers_path }
    subject { page }

    it { should have_selector('table/tbody/tr', count: 3) }
    it { find('table/tbody/tr[2]/td[1]').text.should eq vol_aaa.full_name }
    it { find('table/tbody/tr[3]/td[1]').text.should eq vol_zzz.full_name }
    it "submit form"  do
      fill_in 'search', with: 'z'
      should have_selector('table/tbody/tr', count: 2)
      find('table/tbody/tr[2]/td[1]').text.should eq vol_zzz.full_name 
    end
  end
end
