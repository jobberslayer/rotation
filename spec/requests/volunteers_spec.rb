require 'spec_helper'

describe "Volunteers" do
  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }  

  describe "GET /volunteers" do
    before { get volunteers_url }
    it { response.status.should be(200) }
    it { page.title.should eq full_title('Volunteers')}
  end
end
