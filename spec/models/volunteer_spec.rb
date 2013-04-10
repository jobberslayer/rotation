require 'spec_helper'

describe Volunteer do
  describe "created empty" do 

    subject {Volunteer.new()}

    it {should respond_to :first_name}
    it {should respond_to :last_name}
    it {should respond_to :email}
    it {should respond_to :full_name}
    it { should respond_to(:vol_group_relationships) }

    it {should_not be_valid}
  end

  describe "created with factory" do
    subject {FactoryGirl.create(:volunteer) }
    it {should be_valid}

    context "when first_name is not present" do
      before { subject.first_name = " " }
      it {should_not be_valid}
    end
    context "when last_name is not present" do
      before {subject.last_name = " "}
      it {should_not be_valid}
    end
    context "when email is not present" do
      before {subject.email = " "}
      it {should_not be_valid}
    end
    context "when fname is too long" do
      before {subject.first_name = "a"*51}
      it {should_not be_valid}
    end
    context "when lname is too long" do
      before {subject.last_name = "a"*51}
      it {should_not be_valid}
    end
    context "when email is too long" do
      before {subject.email = "a"*51}
      it {should_not be_valid}
    end
    context "when email format is correct" do
      it "should be valid" do
        addresses = %w[me@example.com test@a.b.c.org me+thisguy@example.tv]
        addresses.each do |address|
          subject.email = address
          should be_valid
        end
      end
    end
    context "when email format is incorrect" do
      it "should be invalid" do
        addresses = %w[me@example,com test@a.b.c. vol@bad+address.tv]
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

    context "reset using full_name" do
      context "with 2 word name" do 
        before do
          subject.full_name = "First Last"
          subject.save
        end

        its(:first_name) {should eq 'First'}
        its(:last_name) {should eq 'Last'}
      end
      context "with 3 word name" do
        before do
          subject.full_name = "First Middle Last"
          subject.save
        end

        its(:first_name) {should eq 'First Middle'}
        its(:last_name)  {should eq 'Last'}
      end
      context "with 4 word name" do
        before do
          subject.full_name = "First Middle Extra Last"
          subject.save
        end

        its(:first_name) {should eq 'First Middle Extra'}
        its(:last_name)  {should eq 'Last'}
      end
    end
    context "find by" do
      it "full_name" do 
        vol_found = Volunteer.find_by_full_name(subject.first_name + " " + subject.last_name)
        subject.first_name.should eq vol_found.first_name
        subject.last_name.should eq vol_found.last_name
      end
    end
    context "signed up for group" do
      let(:group) { FactoryGirl.create(:group) }

      before do 
        subject.join!(group)
      end

      let(:relationship) { VolGroupRelationship.find_by_volunteer_id_and_group_id(subject.id, group.id) }

      it {relationship.should_not be_disabled}

    end

    context "leave group" do
      let(:group) { FactoryGirl.create(:group) }

      before do 
        subject.join!(group)
        subject.leave!(group)
      end

      let(:relationship) { VolGroupRelationship.find_by_volunteer_id_and_group_id(subject.id, group.id) }

      it {relationship.should be_disabled}
    end

    context "active groups" do
      let(:group) { FactoryGirl.create(:group) }

      before { subject.join!(group) }

      it { subject.active_groups.size.should eq 1 }
    end

    context "joined?" do
      let(:group) { FactoryGirl.create(:group) }

      before { subject.join!(group) }

      let(:relationship) { VolGroupRelationship.find_by_volunteer_id_and_group_id(subject.id, group.id) }

      it { should be_joined(group) }
    end

    context "not joined" do
      let(:group) { FactoryGirl.create(:group) }
      
      it{subject.not_joined.size.should eq 0}
    end

    context "groups scheduled for" do
      let(:vol_scheduled) do
        year, month, day = DateHelp.today
        FactoryGirl.create(:volunteer_scheduled_for_group, year: year, month: month, day: day)
      end
      
      it{ Volunteer.scheduled_for(vol_scheduled.groups.first, *DateHelp.today).size.should eq 1 }
    end
    
  end

  context "search" do
    let(:vol1) { FactoryGirl.create(:volunteer, first_name: 'Will', last_name: 'Whetton', email: 'willwhetton@example.com') }
    let(:vol2) { FactoryGirl.create(:volunteer, first_name: 'William', last_name: 'Tell', email: 'willtell@example.com') }
    let(:vol3) { FactoryGirl.create(:volunteer, first_name: 'Bill', last_name: 'Whetton', email: 'billwhetton@example.com') }

    before do
      vol1.save
      vol2.save
      vol3.save
    end

    context "by first name" do
      it "one found" do
        vols = Volunteer.search('William')
        vols.size.should eq 1
        vols.first.last_name.should eq 'Tell'
      end
      it "two found" do
        vols = Volunteer.search('Will')
        vols.size.should eq 2
      end
      it "lower case two found" do
        vols = Volunteer.search('will')
        vols.size.should eq 2
      end
    end

    context "by email" do
      it "one found" do
        vols = Volunteer.search('willtell@example.com')
        vols.size.should eq 1
        vols.first.first_name.should eq 'William'
      end
      it "three found" do
        vols = Volunteer.search('example.com')
        vols.size.should eq 3
      end
      it "mixed case two found" do
        vols = Volunteer.search('Whetton@Example.com')
        vols.size.should eq 2
      end
    end
  end
end
