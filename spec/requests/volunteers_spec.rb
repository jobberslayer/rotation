require 'spec_helper'
include ApplicationHelper

describe "Volunteers" do
  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }  

  describe "GET /volunteers" do
    before { visit volunteers_url }
    it { page.status_code.should be(200) }
    it { page.find('title').text.should eq full_title('Volunteers') }
  end
end
