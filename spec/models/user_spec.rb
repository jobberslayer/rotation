require 'spec_helper'

describe User do
  let(:user) { User.new(
      fname: "Me", 
      lname: "Thisguy", 
      uname: "me", 
      email:"me@example.com",
      password: "foobar", 
      password_confirmation: "foobar"
  ) }

  subject {user}

  it { should respond_to(:fname) }
  it { should respond_to(:lname) }
  it { should respond_to(:uname) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:remember_token) }

  it {should be_valid}

  describe "remember token" do
    before { user.save }
    its(:remember_token) { should_not be_blank }
  end

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
      addresses = %w[me@example.com test@a.b.c.org me+thisguy@example.tv]
      addresses.each do |address|
        user.email = address
        user.should be_valid
      end
    end
  end
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[me@example,com test@a.b.c. user@bad+address.tv]
      addresses.each do |address|
        user.email = address
        user.should_not be_valid
      end
    end
  end

  describe "when user with same uname" do
    before do
      user_with_same_uname = user.dup
      user_with_same_uname.uname = user.uname.upcase
      user_with_same_uname.save
    end

    it { should_not be_valid }

  end

  describe "when email contains uppercase" do
    before do
      user.email = "Me@Example.com"
      user.save      
    end

    it "should downcase email" do 
      user.email.should eq user.email.downcase
    end
  end
  describe "when uname contains uppercase" do
    before do
      user.uname = "Me"
      user.save      
    end

    it "should downcase uname" do
      user.uname.should eq user.uname.downcase
    end
  end

  describe "when password is not present" do
    before { user.password = user.password_confirmation = " " }
    it { should_not be_valid }
  end
  describe "when password doesn't match confirmation" do
    before { user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end
  describe "when password confirmation is nil" do
    before { user.password_confirmation = nil }
    it { should_not be_valid }
  end

  describe "return value of authenticate method" do
    before { user.save }
    let(:found_user) { User.find_by_email(user.email) }

    describe "with valid password" do
      it { should == found_user.authenticate(user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end
  end
end
