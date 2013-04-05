require 'spec_helper'

describe Group do
  describe "created with empty" do
    subject {Group.new}

    it {should respond_to :name}
    it {should respond_to :email}
    it {should respond_to :rotation}
    it {should respond_to :email_body}
    it {should_not be_rotation}

    it {should_not be_valid}
  end

  describe "created with factory" do
    subject { FactoryGirl.create(:group) }

    it {should be_valid}

    context "when rotation set to true" do
      before do
        subject.save!
        subject.toggle!(:rotation)
      end

      it {should be_rotation}
    end

    context "when name is not present" do
      before {subject.name = " " }
      it {should_not be_valid}
    end

    context "when email is not present" do
      before {subject.email = " "}
      it {should_not be_valid}
    end

    context "when email format is valid" do
      it "should be valid" do
        addresses = %w[me@example.com test@a.b.c.org me+thisguy@example.tv]
        addresses.each do |address|
          subject.email = address
          should be_valid
        end
      end
    end
    context "when email format is invalid" do
      it "should be invalid" do
        addresses = %w[me@example,com test@a.b.c. group@bad+address.tv]
        addresses.each do |address|
          subject.email = address
          should_not be_valid
        end
      end
    end
    context "when email contains uppercase" do
      before do
        subject.email = "Me@Example.com"
        subject.save      
      end
      it "should downcase email" do 
        subject.email.should eq subject.email.downcase
      end
    end

    context "added volunteer" do
      let(:vol) { FactoryGirl.create(:volunteer) }

      before { subject.sign_up!(vol) }

      it { should be_signed_up(vol) }
    end
  end
end
