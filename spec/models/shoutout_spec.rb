require 'rails_helper'

RSpec.describe Shoutout, type: :model do
  it { should have_many(:cheers) }
  it { should serialize(:recipients) }

  describe "since_sunday_morning query" do
    it 'should only return shoutouts from this week' do
      Shoutout.delete_all
      create(:shoutout, created_at: 10.days.ago)
      create(:shoutout)
      expect(Shoutout.since_sunday_morning.size).to be 1
    end
  end

  describe "shoutout undo" do
    it 'should remove the latest shoutout for the given user' do
      Shoutout.delete_all
      name = create(:shoutout).sender
      result = Shoutout.undo_latest_for_user(name)
      expect(Shoutout.where(sender: name).count).to be 0
      expect(result).to be true
    end

    it 'should return false if there was no shoutout to delete' do
      result = Shoutout.undo_latest_for_user('Jiff')
      expect(result).to be false
    end

    it 'should remove associated cheers too' do
      shoutout = create(:shoutout)
      create(:cheer, shoutout: shoutout)

      Shoutout.undo_latest_for_user(shoutout.sender)
      expect(Cheer.where(shoutout: shoutout).count).to be 0
    end
  end
end
