require 'rails_helper'

RSpec.describe ShoutoutsHelper, type: :helper do
  describe "highlight" do
    it "should mark usernames in the test" do
      expect(helper.highlight_usernames('hello @name', %w(name)))
        .to eq 'hello <mark>@name</mark>'
    end
  end

  describe "time_ago_message" do
    it "should remove about" do
      expect(helper.time_ago_message((59.1).minutes.ago))
        .to_not include('about')
    end

    it "should remove less than a" do
      expect(helper.time_ago_message(20.seconds.ago)).to_not include('less')
    end

    it "should substitute m for minute(s)" do
      expect(helper.time_ago_message(1.minute.ago)).to_not include('minute')
      expect(helper.time_ago_message(10.minutes.ago)).to_not include('minutes')
    end

    it "should substitute h for hour(s)" do
      expect(helper.time_ago_message(1.hour.ago)).to_not include('hour')
      expect(helper.time_ago_message(10.hours.ago)).to_not include('hours')
    end

    it "should substitute d for day(s)" do
      expect(helper.time_ago_message(1.day.ago)).to_not include('day')
      expect(helper.time_ago_message(10.days.ago)).to_not include('days')
    end

    it 'should append "ago"' do
      expect(helper.time_ago_message(10.minutes.ago)).to match(/ago$/)
    end
  end

  describe "format_recipients" do
    it "should use & correctly" do
      expect(helper.format_recipients(%w(Jeff Bob)))
        .to eq "<strong>Jeff</strong> & <strong>Bob</strong>"
    end

    it "should use ',' correctly" do
      expect(helper.format_recipients(%w(Jeff Bob Bill)))
        .to eq "<strong>Jeff</strong>, <strong>Bob</strong> & <strong>Bill</strong>"
    end
  end

  describe "count_unique_senders" do
    it "should count the list's unique senders" do
      shoutouts = [
        build(:shoutout, sender: 'Jeff'),
        build(:shoutout, sender: 'Jeff'),
        build(:shoutout, sender: 'Bob')
      ]
      expect(helper.unique_senders_count(shoutouts)).to be 2
    end
  end

  describe "count_unique_recipients" do
    it "should count the list's unique recipients" do
      shoutouts = [
        build(:shoutout, recipients: %w(Jeff Bob)),
        build(:shoutout, recipients: %w(Bob Jim)),
        build(:shoutout, recipients: %w(Jeff Tom Dom Bom))
      ]
      expect(helper.unique_recipients_count(shoutouts)).to be 6
    end
  end

  describe "cheer_count" do
    it "should count the list's cheers" do
      shoutouts = [
        create(:shoutout, recipients: %w(Jeff Bob)),
        create(:shoutout, recipients: %w(Bob Jim))
      ]
      create(:cheer, shoutout: shoutouts.first)
      create(:cheer, shoutout: shoutouts.last)
      expect(helper.cheer_count(shoutouts)).to be 2
    end
  end
end
