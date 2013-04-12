require 'spec_helper'
include ApplicationHelper

describe "Volunteers" do
  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }  

  describe "GET /volunteers" do
    before { visit volunteers_url }

    subject {page}
    it { subject.status_code.should be(200) }
    it { find('title').text.should eq full_title('Volunteers') }

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
      page.find('.alert.alert-success').text.should eq "Volunteer #{changed_vol.full_name} updated."
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
      find('table/tr[1]/th[1]').text.should eq 'Name'
      find('table/tr[1]/th[2]').text.should eq 'Email'
      find('table/tr[1]/th[3]').text.should eq ''
      find('table/tr[1]/th[3]').text.should eq ''
      page.should have_no_selector('table/tr[1]/th[4]')

      find('table/tr[2]/td[1]').text.should eq volunteer.groups.first.name
      find('table/tr[2]/td[2]').text.should eq volunteer.groups.first.email
    end
  end

  describe "removing volunteer" do
    let!(:volunteer) { FactoryGirl.create(:volunteer) }
    before do
      visit volunteers_url
    end

    it "click remove" do
      remove_link = find('table/tr[2]/td[5]/a')
      remove_link[:href].should eq volunteer_path(volunteer.id)
      remove_link['data-method'].should eq 'delete'
      remove_link.click
      Volunteer.find(volunteer.id).should be_disabled
    end
  end
end
