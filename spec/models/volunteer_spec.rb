require 'spec_helper'

describe Volunteer do
  let(:vol) { Volunteer.new(
    first_name: "Joe", 
    last_name: "Volunteer",
    email:"joe_vol@example.com"
  )}

  subject {vol}

  it {should respond_to :first_name}
  it {should respond_to :last_name}
  it {should respond_to :email}
  it {should respond_to :full_name}

  it {should be_valid}

  describe "when first_name is not present" do
    before {vol.first_name = " " }
    it {should_not be_valid}
  end
  describe "when last_name is not present" do
    before {vol.last_name = " "}
    it {should_not be_valid}
  end
  describe "when email is not present" do
    before {vol.email = " "}
    it {should_not be_valid}
  end

  describe "when fname is too long" do
    before {vol.first_name = "a"*51}
    it {should_not be_valid}
  end
  describe "when lname is too long" do
    before {vol.last_name = "a"*51}
    it {should_not be_valid}
  end
  describe "when email is too long" do
    before {vol.email = "a"*51}
    it {should_not be_valid}
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[me@example.com test@a.b.c.org me+thisguy@example.tv]
      addresses.each do |address|
        vol.email = address
        vol.should be_valid
      end
    end
  end
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[me@example,com test@a.b.c. vol@bad+address.tv]
      addresses.each do |address|
        vol.email = address
        vol.should_not be_valid
      end
    end
  end
  describe "when email contains uppercase" do
    before do
      vol.email = "Me@Example.com"
      vol.save      
    end

    it "should downcase email" do 
      vol.email.should eq vol.email.downcase
    end
  end

  describe "when full_name attribute is used to save" do
    # if only one word name assumes it is the last name
    describe "with 1 word name" do
      before do
        vol.full_name = "Last"
        vol.save
      end

      it {vol.first_name.should eq ''}
      it {vol.last_name.should eq 'Last'}
    end
    describe "with 2 word name" do
      before do
        vol.full_name = "First Last"
        vol.save
      end

      it {vol.first_name.should eq 'First'}
      it {vol.last_name.should eq 'Last'}
    end
    describe "with 3 word name" do
      before do
        vol.full_name = "First Middle Last"
        vol.save
      end

      it {vol.first_name.should eq 'First Middle'}
      it {vol.last_name.should eq 'Last'}
    end
    describe "with 4 word name" do
      before do
        vol.full_name = "First Middle Extra Last"
        vol.save
      end

      it {vol.first_name.should eq 'First Middle Extra'}
      it {vol.last_name.should eq 'Last'}
    end
  end

end
