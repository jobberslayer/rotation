require 'spec_helper'

describe Job do
  let(:job) { Job.new(
    name: "Greeters", 
    email:"greeters@example.com"
  )}

  subject {job}

  it {should respond_to :name}
  it {should respond_to :email}

  it {should be_valid}

  describe "when first_name is not present" do
    before {job.name = " " }
    it {should_not be_valid}
  end

  describe "when email is not present" do
    before {job.email = " "}
    it {should_not be_valid}
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[me@example.com test@a.b.c.org me+thisguy@example.tv]
      addresses.each do |address|
        job.email = address
        job.should be_valid
      end
    end
  end
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[me@example,com test@a.b.c. job@bad+address.tv]
      addresses.each do |address|
        job.email = address
        job.should_not be_valid
      end
    end
  end
  describe "when email contains uppercase" do
    before do
      job.email = "Me@Example.com"
      job.save      
    end
    it "should downcase email" do 
      job.email.should eq job.email.downcase
    end
  end
end
