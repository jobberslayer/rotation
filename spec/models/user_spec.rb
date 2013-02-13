require 'spec_helper'

describe User do
  let(:user) { User.new(fname: "Kevin", lname: "Lester", uname: "wklester", email:"kevin@e-kevin.com") }

  subject {user}

  it { should respond_to(:fname) }
  it { should respond_to(:lname) }
  it { should respond_to(:uname) }
  it { should respond_to(:email) }

  describe "when fname is not present" do
    before {user.fname = " " }
    it {should_not be_valid}
  end
  describe "when lname is not present" do
    before {user.lname = " "}
    it {should_not be_valid}
  end
  describe "when uname is not present" do
    before {user.uname = " "}
    it {should_not be_valid}
  end
  describe "when email is not present" do
    before {user.email = " "}
    it {should_not be_valid}
  end

  describe "when fname is too long" do
    before {user.fname = "a"*51}
    it {should_not be_valid}
  end
  describe "when lname is too long" do
    before {user.lname = "a"*51}
    it {should_not be_valid}
  end
  describe "when uname is too long" do
    before {user.uname = "a"*51}
    it {should_not be_valid}
  end
  describe "when email is too long" do
    before {user.email = "a"*51}
    it {should_not be_valid}
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[kevin@lester.com test@a.b.c.org kevin+lester@example.tv]
      addresses.each do |address|
        user.email = address
        user.should be_valid
      end
    end
  end
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[kevin@lester,com test@a.b.c. kevin@bad+address.tv]
      addresses.each do |address|
        user.email = address
        user.should_not be_valid
      end
    end
  end
end
