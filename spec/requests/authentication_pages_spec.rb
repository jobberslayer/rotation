require 'spec_helper'

describe "AuthenticationPages" do

  subject { page }

  describe "signin" do
    before { visit signin_path }

    it { should have_selector 'h1',    text: 'Sign in'}
    it { should have_selector 'title', text: 'Sign in'}
    it { should have_css '#session_uname', text: '' }
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
  end
end
