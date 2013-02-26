require 'spec_helper'

describe Group do
  let(:group) { FactoryGirl.create(:group) }

  subject {group}

  it {should respond_to :name}
  it {should respond_to :email}
  it {should respond_to :rotation}
  it {should_not be_rotation}

  it {should be_valid}

  describe "when rotation set to true" do
    before do
      group.save!
      group.toggle!(:rotation)
    end

    it {should be_rotation}
  end

  describe "when first_name is not present" do
    before {group.name = " " }
    it {should_not be_valid}
  end

  describe "when email is not present" do
    before {group.email = " "}
    it {should_not be_valid}
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[me@example.com test@a.b.c.org me+thisguy@example.tv]
      addresses.each do |address|
        group.email = address
        group.should be_valid
      end
    end
  end
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[me@example,com test@a.b.c. group@bad+address.tv]
      addresses.each do |address|
        group.email = address
        group.should_not be_valid
      end
    end
  end
  describe "when email contains uppercase" do
    before do
      group.email = "Me@Example.com"
      group.save      
    end
    it "should downcase email" do 
      group.email.should eq group.email.downcase
    end
  end

  describe ""

  describe "added volunteer" do
    let(:vol) { FactoryGirl.create(:volunteer) }

    before { group.signed_up!(vol) }

    it { should be_signed_up(vol) }
  end
end
