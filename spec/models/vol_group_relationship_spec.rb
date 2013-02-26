require 'spec_helper'

describe VolGroupRelationship do
  let(:vol) { FactoryGirl.create(:volunteer) }
  let(:group) { FactoryGirl.create(:group) }
  let(:relationship) {vol.vol_group_relationships.build(group_id: group.id) }

  subject { relationship }

  it { should be_valid }

end
