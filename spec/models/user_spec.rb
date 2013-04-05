require 'spec_helper'

describe User do
  subject {FactoryGirl.create(:user)}

  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:user_name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:remember_token) }

  it {should be_valid}

  describe "remember token" do
    before { subject.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "when fname is not present" do
    before {subject.first_name = " " }
    it {should_not be_valid}
  end
  describe "when lname is not present" do
    before {subject.last_name = " "}
    it {should_not be_valid}
  end
  describe "when user_name is not present" do
    before {subject.user_name = " "}
    it {should_not be_valid}
  end
  describe "when email is not present" do
    before {subject.email = " "}
    it {should_not be_valid}
  end

  describe "when fname is too long" do
    before {subject.first_name = "a"*51}
    it {should_not be_valid}
  end
  describe "when lname is too long" do
    before {subject.last_name = "a"*51}
    it {should_not be_valid}
  end
  describe "when user_name is too long" do
    before {subject.user_name = "a"*51}
    it {should_not be_valid}
  end
  describe "when email is too long" do
    before {subject.email = "a"*51}
    it {should_not be_valid}
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[me@example.com test@a.b.c.org me+thisguy@example.tv]
      addresses.each do |address|
        subject.email = address
        should be_valid
      end
    end
  end
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[me@example,com test@a.b.c. user@bad+address.tv]
      addresses.each do |address|
        subject.email = address
        should_not be_valid
      end
    end
  end

  describe "when user with same user_name" do
    let(:dup_user) { subject.dup }

    before do
      dup_user.user_name = subject.user_name.upcase
      dup_user.save
    end

    it { dup_user.should_not be_valid }

  end

  describe "when email contains uppercase" do
    before do
      subject.email = "Me@Example.com"
      subject.save      
    end

    it "should downcase email" do 
      subject.email.should eq subject.email.downcase
    end
  end
  describe "when user_name contains uppercase" do
    before do
      subject.user_name = "Me"
      subject.save      
    end

    it "should downcase user_name" do
      subject.user_name.should eq subject.user_name.downcase
    end
  end

  describe "when password is not present" do
    before { subject.password = subject.password_confirmation = " " }
    it { should_not be_valid }
  end
  describe "when password doesn't match confirmation" do
    before { subject.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end
  describe "when password confirmation is nil" do
    before { subject.password_confirmation = nil }
    it { should_not be_valid }
  end

  describe "return value of authenticate method" do
    before { subject.save }
    let(:found_user) { User.find_by_email(subject.email) }

    describe "with valid password" do
      it { should == found_user.authenticate(subject.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end
  end

  describe "when full_name attribute is used to save" do
    # if only one word name assumes it is the last name
    describe "with 1 word name" do
      before do
        subject.full_name = "Last"
        subject.save
      end

      its(:first_name) {should eq ''}
      its(:last_name) {should eq 'Last'}
    end
    describe "with 2 word name" do
      before do
        subject.full_name = "First Last"
        subject.save
      end

      its(:first_name) {should eq 'First'}
      its(:last_name) {should eq 'Last'}
    end
    describe "with 3 word name" do
      before do
        subject.full_name = "First Middle Last"
        subject.save
      end

      its(:first_name) {should eq 'First Middle'}
      its(:last_name)  {should eq 'Last'}
    end
    describe "with 4 word name" do
      before do
        subject.full_name = "First Middle Extra Last"
        subject.save
      end

      its(:first_name) {should eq 'First Middle Extra'}
      its(:last_name) {should eq 'Last'}
    end
  end
end
