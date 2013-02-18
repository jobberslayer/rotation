require 'spec_helper'

describe "EditProfiles" do
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }  

  describe "edit profile" do    
    before { visit "/profile" }
    let(:new_email) { "new_#{user.email}" }
    before {
      #save_and_open_page
      fill_in "Email",                 with: new_email
      fill_in "Password",              with: user.password
      fill_in "Password confirmation", with: user.password

      click_button "Save changes"
    }

    let(:changed_user) { User.find(user.id) }

    it {changed_user.email.should eq new_email}
  end
end
