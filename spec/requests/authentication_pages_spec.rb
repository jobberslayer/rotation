require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin" do
    before { visit signin_path }

    it { should have_selector 'h1',    text: 'Sign in'}
    it { should have_selector 'title', text: 'Sign in'}
    it { should have_css '#session_user_name', text: '' }
    it { should have_css '#session_password', text: '' }

    describe "with invalid info" do 
      before {click_button "Sign in"}

      it { should have_selector 'title', text: 'Sign in'}
      it { should have_selector 'div.alert.alert-error', text: 'Invalid'}

      #Make sure flash error message isn't carrying on to next page
      describe "after visiting another page" do
        before {click_link "Sign in"}

        it {should_not have_selector 'div.alert.alert-error'}
      end
    end

    describe "with valid info" do
      let(:user) { FactoryGirl.create(:user) }
      before { valid_signin user}
      
      it { should have_selector 'h1', text: 'News'}
    end

    describe "already signed in" do
      let(:user) { FactoryGirl.create(:user) }
      before { valid_signin user}
      before { visit signin_path }
      it { should have_selector 'h1', text: 'News'}
      it { should have_selector 'div.alert.alert-notice', text: 'Already signed in.'}
    end
  end
end
