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
  end
end
