require 'spec_helper'
include ApplicationHelper

describe "Groups" do
  describe "get while not logged in" do
    before { visit groups_path }
    it { page.should redirect_to_signin }
  end
end

describe "Groups" do
  let(:user) { FactoryGirl.create(:user) }
  before {sign_in user}

  describe "root" do
    let!(:group) { FactoryGirl.create(:group) }
    before { visit groups_path }

    subject { page } 

    it { should_not redirect_to_signin }
    it { subject.status_code.should be(200) }
   
    it { find('title').text.should eq full_title('Groups') }  

    context "add form" do
      it { should have_selector('#group_name') }
      it { should have_selector('#group_email') }
      it { should have_selector('input', type: 'submit', name: 'commit', value: 'Add Group') }
    end

    context "volunteer table" do
      it { should have_selector('legend', text: 'Groups') }
      it { find('table/tr[1]/th[1]').text.should eq 'Name' }
      it { find('table/tr[1]/th[2]').text.should eq 'Email' }
      it { find('table/tr[1]/th[3]').text.should eq 'Rotation' }
      it { find('table/tr[1]/th[4]').text.should eq '' }
      it { find('table/tr[1]/th[5]').text.should eq '' }
      it { find('table/tr[1]/th[6]').text.should eq '' }
      it { find('table/tr[1]/th[7]').text.should eq '' }
      it { find('table/tr[1]/th[8]').text.should eq '' }
      it { should_not have_selector('table/tr[1]/th[9]') }

      it { find('table/tr[2]/td[1]').text.should eq group.name }
      it { find('table/tr[2]/td[2]').text.should eq group.email }
      it { find('table/tr[2]/td[3]').text.should eq group.rotation?.to_s }
      it { find('table/tr[2]/td[4]').text.strip.should eq 'edit' }
      it { find('table/tr[2]/td[5]').text.should eq 'volunteers' }
      it { find('table/tr[2]/td[6]').text.should eq 'export' }
      it { find('table/tr[2]/td[7]').text.should eq '' }
      it { find('table/tr[2]/td[8]').text.strip.should eq 'remove' }
      it { should_not have_selector('table/tr[2]/td[9]') }
    end
  end
end
