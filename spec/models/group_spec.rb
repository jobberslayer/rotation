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

    context "find sunday volunteers" do
      let(:group_with_vol) {FactoryGirl.create(:group_with_scheduled_volunteer_sunday)}
      it { group_with_vol.sunday_volunteers.size.should eq 1 }
      it { group_with_vol.next_sunday_volunteers.size.should eq 0 }
    end

    context "find next sunday volunteers" do
      let(:group_with_vol) {FactoryGirl.create(:group_with_scheduled_volunteer_next_sunday)}
      it { group_with_vol.next_sunday_volunteers.size.should eq 1 }
      it { group_with_vol.sunday_volunteers.size.should eq 0 }
    end

    context "find volunteers scheduled for today" do
      let(:group_with_vol) do
        year, month, day = DateHelp.today
        FactoryGirl.create(:group_with_scheduled_for, year: year, month: month, day: day)
      end
      it { group_with_vol.scheduled_volunteers(*DateHelp.today).size.should eq 1 }
    end

    context "clear out the scedule" do
      let(:group_with_vol) do
        year, month, day = DateHelp.today
        FactoryGirl.create(:group_with_scheduled_for, year: year, month: month, day: day)
      end
      before { group_with_vol.clear_schedule(*DateHelp.today) }
      it { group_with_vol.scheduled_volunteers(*DateHelp.today).size.should eq 0 }
    end

    context "bench volunteer" do
      let(:vol) { FactoryGirl.create(:volunteer) }
      before do
        subject.sign_up!(vol)
        subject.bench!(vol)
      end
      let(:relation) { VolGroupRelationship.find_by_group_id_and_volunteer_id(subject.id, vol.id) }
      
      it { should_not be_signed_up(vol) }
      it { relation.should be_disabled } 
    end

    context "find active volunteer" do
      let(:vol1) { FactoryGirl.create(:volunteer) }
      let(:vol2) { FactoryGirl.create(:volunteer) }

      before do
        subject.sign_up!(vol1)
        subject.sign_up!(vol2)
        subject.bench!(vol1)
      end

      it { subject.active_volunteers.size.should eq 1 }
    end

    context "disable" do 
      let(:vol) { FactoryGirl.create(:volunteer) }
      before do
        subject.sign_up!(vol)
        subject.disable
      end

      it { subject.should be_disabled }
      it { subject.active_volunteers.size.should eq 0 }
    end

    context "volunteers changed since" do
      let(:vol) { FactoryGirl.create(:volunteer) }
      before do
        subject.sign_up!(vol)
      end 

      it { subject.volunteers_changed_since((DateTime.now - 1.second).utc).size.should eq 1 }
      it { subject.volunteers_changed_since((DateTime.now + 1.second).utc).size.should eq 0 }
    end
  end
end
