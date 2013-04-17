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
    let!(:group) { FactoryGirl.create(:group_with_scheduled_volunteer_sunday) }
    let!(:group_next) { FactoryGirl.create(:group_with_scheduled_volunteer_next_sunday) }
    let!(:need_volunteers) { '[Need to add volunteers]' }

    before do
      sign_in user
      visit index_schedule_path
    end

    subject { page }
    it "should redirect to this coming Sunday" do
      current_path.should eq list_schedule_path(*DateHelp.get_next_sunday)
      find('title').text.should eq full_title("Schedules")
      find('h2').text.should eq Formatters.formal_date(*DateHelp.get_next_sunday)

      find('table/tr[1]/th[1]').text.should eq 'Group'
      find('table/tr[1]/th[2]').text.should eq 'Volunteers'
      find('table/tr[1]/th[3]').text.should eq ''

      find('table/tr[2]/td[1]').text.should eq group.name
      find('table/tr[2]/td[2]').text.should eq (group.volunteers.map{ |v| v.full_name }).join(', ')
      find('table/tr[2]/td[3]').text.should eq 'edit'

      find('table/tr[3]/td[1]').text.should eq group_next.name
      find('table/tr[3]/td[2]').text.should eq need_volunteers 
      find('table/tr[3]/td[3]').text.should eq 'edit'

      should have_no_selector('table/tr[4]')

      should have_selector('a', text: '<< previous Sunday')
      should have_selector('a', text: 'next Sunday >>')
    end

    it "previous Sunday" do
      prev_year, prev_month, prev_day = DateHelp.previous_week(*DateHelp.get_next_sunday)
      prev_link = find('a', text: '<< previous Sunday')
      
      prev_link[:href].should eq list_schedule_path(prev_year, prev_month, prev_day)
      prev_link.click

      find('h2').text.should eq Formatters.formal_date(prev_year, prev_month, prev_day)
      find('table/tr[2]/td[1]').text.should eq group.name 
      find('table/tr[2]/td[2]').text.should eq need_volunteers 
      find('table/tr[3]/td[1]').text.should eq group_next.name 
      find('table/tr[3]/td[2]').text.should eq need_volunteers 

      should have_no_selector('table/tr[4]')
    end

    it "next Sunday" do
      next_year, next_month, next_day = DateHelp.next_week(*DateHelp.get_next_sunday)
      next_link = find('a', text: 'next Sunday >>')
      
      next_link[:href].should eq list_schedule_path(next_year, next_month, next_day)
      next_link.click

      find('h2').text.should eq Formatters.formal_date(next_year, next_month, next_day)
      find('table/tr[2]/td[1]').text.should eq group.name 
      find('table/tr[2]/td[2]').text.should eq need_volunteers 

      find('table/tr[3]/td[1]').text.should eq group_next.name 
      find('table/tr[3]/td[2]').text.should eq (group_next.volunteers.map { |v| v.full_name }).join(', ')

      should have_no_selector('table/tr[4]')
    end

    it "edit" do
      volunteer = group.volunteers.first
      extra_volunteer = FactoryGirl.create(:volunteer)
      group.volunteers << extra_volunteer
      
      edit_link = find('table/tr[2]/td[3]/a')
      edit_link.text.should eq 'edit'
      edit_link[:href].should eq edit_schedule_url(*DateHelp.get_next_sunday, group.id)
      edit_link.click

      find('h3').text.should include(Formatters.formal_date(*DateHelp.get_next_sunday))
      current_path.should eq edit_schedule_path(*DateHelp.get_next_sunday, group.id)
      find('table/tr[1]/td[1]/input', type: 'checkbox', value: volunteer.id ).should be_checked
      find('table/tr[1]/td[2]').text.should eq volunteer.full_name
      find('table/tr[1]/td[3]').text.strip.should eq "<#{volunteer.email}>"

      find('table/tr[2]/td[1]/input', type: 'checkbox', value: extra_volunteer.id ).should_not be_checked
      find('table/tr[2]/td[2]').text.should eq extra_volunteer.full_name
      find('table/tr[2]/td[3]').text.strip.should eq "<#{extra_volunteer.email}>"

      find('table/tr[2]/td[1]/input').set(true)
      click_button 'Save'
      current_path.should eq list_schedule_path(*DateHelp.get_next_sunday)

      find('table/tr[2]/td[1]').text.should eq group.name 
      find('table/tr[2]/td[2]').text.should eq (group.volunteers.map { |v| v.full_name }).join(', ')
    end

    it "edit cancel with back" do
      volunteer = group.volunteers.first
      extra_volunteer = FactoryGirl.create(:volunteer)
      group.volunteers << extra_volunteer
      
      edit_link = find('table/tr[2]/td[3]/a')
      edit_link.text.should eq 'edit'
      edit_link[:href].should eq edit_schedule_url(*DateHelp.get_next_sunday, group.id)
      edit_link.click

      find('h3').text.should include(Formatters.formal_date(*DateHelp.get_next_sunday))
      current_path.should eq edit_schedule_path(*DateHelp.get_next_sunday, group.id)
      find('table/tr[1]/td[1]/input', type: 'checkbox', value: volunteer.id ).should be_checked
      find('table/tr[1]/td[2]').text.should eq volunteer.full_name
      find('table/tr[1]/td[3]').text.strip.should eq "<#{volunteer.email}>"

      find('table/tr[2]/td[1]/input', type: 'checkbox', value: extra_volunteer.id ).should_not be_checked
      find('table/tr[2]/td[2]').text.should eq extra_volunteer.full_name
      find('table/tr[2]/td[3]').text.strip.should eq "<#{extra_volunteer.email}>"

      find('table/tr[2]/td[1]/input').set(true)
      click_link 'Back'
      current_path.should eq list_schedule_path(*DateHelp.get_next_sunday)

      find('table/tr[2]/td[1]').text.should eq group.name 
      find('table/tr[2]/td[2]').text.should eq group.volunteers.first.full_name
      find('table/tr[2]/td[2]').text.should_not include(extra_volunteer.full_name)
    end
  end
end
