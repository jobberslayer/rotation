require 'spec_helper'

describe "Volunteers" do
  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }  

  describe "GET /volunteers" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      puts volunteers_url
      get volunteers_url
      response.status.should be(200)
    end
  end
end
