require "spec_helper"

describe RotationMailer do
  describe "check change log email" do
    ActionMailer::Base.delivery_method = :test
    RotationMailer.changes_email.deliver
    last_email = ActionMailer::Base.deliveries.last

    it { last_email.subject.should eq 'Changes made to volunteers/groups.' }

    context "all to addresses are correct" do
      last_email.to.each do |email|
        it { EMAIL_ADMINS.should include(email) }
      end
    end

    context "all from addresses are correct" do 
      last_email.from.each do |email|
        it { EMAIL_FROM.should include(email) }
      end
    end

    it {last_email.body.raw_source.should include(index_change_log_url)}
    it {last_email.subject.should include() }
  end

  describe "send group email" do
    let(:group) { FactoryGirl.create(:group, email_body: 'thisweek <%=this_week_vols%> for <%=this_week%> nextweek <%=next_week%> <%=next_week_vols%>') }
    let(:vol1) { FactoryGirl.create(:volunteer) }
    let(:vol2) { FactoryGirl.create(:volunteer) }
    let(:vol3) { FactoryGirl.create(:volunteer) }
    let(:vol4) { FactoryGirl.create(:volunteer) }

    before do
      group.volunteers << vol1
      group.volunteers << vol2
      group.volunteers << vol3
      group.volunteers << vol4

      Schedule.for_service(vol1, group, *DateHelp.get_next_sunday)
      Schedule.for_service(vol3, group, *DateHelp.get_next_sunday)
      Schedule.for_service(vol4, group, *DateHelp.next_week(*DateHelp.get_next_sunday))

      ActionMailer::Base.delivery_method = :test
      RotationMailer.send_group_email(group, group.email).deliver
    end

    let(:last_email) { ActionMailer::Base.deliveries.last }

    it { last_email.subject.should eq "#{group.name} rotation reminder" } 
    it { last_email.to.should include(group.email) }

    it "all from addresses are correct" do 
      last_email.from.each do |email|
        EMAIL_FROM.should include(email)
      end
    end

    it { last_email.body.raw_source.should include("#{vol1.first_name} #{vol1.last_name}") }
    it { last_email.body.raw_source.should_not include("#{vol2.first_name} #{vol2.last_name}") }
    it { last_email.body.raw_source.should include("#{vol3.first_name} #{vol3.last_name}") }
    it { last_email.body.raw_source.should include("#{Formatters.date(*DateHelp.get_next_sunday)}") }
    it { last_email.body.raw_source.should include("nextweek #{Formatters.date(*DateHelp.next_week(*DateHelp.get_next_sunday))} #{vol4.first_name} #{vol4.last_name}") }
  end

  describe "send group with no volunteers" do
    let(:group) { FactoryGirl.create(:group, email_body: 'thisweek <%=this_week_vols%> for <%=this_week%> nextweek <%=next_week%> <%=next_week_vols%>') }

    before do
      ActionMailer::Base.delivery_method = :test
      RotationMailer.send_group_email(group, group.email).deliver
    end

    let(:last_email) { ActionMailer::Base.deliveries.last }

    it { last_email.body.raw_source.should include("[Need to add volunteers]") }
  end 

  describe "send group email with test on" do
    let(:group) { FactoryGirl.create(:group, email_body: 'thisweek <%=this_week_vols%> for <%=this_week%> nextweek <%=next_week%> <%=next_week_vols%>') }

    before do
      ActionMailer::Base.delivery_method = :test
      EMAIL_TEST_ON = true if !EMAIL_TEST_ON
      RotationMailer.group_email(group).deliver
    end

    let(:last_email) { ActionMailer::Base.deliveries.last }

    it { last_email.body.raw_source.should include("[Need to add volunteers]") }

    it "to: is correct" do
      last_email.to.each do |email|
        EMAIL_TEST_ADDRESS.should include(email)
      end
    end

    it { last_email.to.should_not include(group.email)}
  end
end
