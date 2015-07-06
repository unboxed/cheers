require 'rails_helper'

RSpec.describe Cheer, type: :model do
  it { should belong_to(:shoutout) }

  describe "latest_for_user query" do
    it 'should return this weeks cheers' do
      shoutout = create(:shoutout)
      cheer1 = create(:cheer, shoutout: shoutout)
      cheer2 = create(:cheer, shoutout: shoutout)
      create(:cheer, shoutout: shoutout, created_at: 10.days.ago)
      expect(Cheer.latest_for_user("sender")).to match_array([cheer1, cheer2])
    end
  end
end
