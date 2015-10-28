require 'rails_helper'

RSpec.describe MetricsService, type: :service do

  describe 'pulling metrics from the database' do
    before :all do
      # this week
      Shoutout.create(sender: 'james', created_at: this_week)
      Shoutout.create(sender: 'james', created_at: this_week)
      Cheer.create(sender: 'sam', created_at: this_week)
      Cheer.create(sender: 'john', created_at: this_week)
      # last week
      Shoutout.create(sender: 'sophie', created_at: weeks_ago(1))
      Cheer.create(sender: 'ellen', created_at: weeks_ago(1))
      # two weeks ago
      Shoutout.create(sender: 'sam', created_at: weeks_ago(2))
      Shoutout.create(sender: 'richard', created_at: weeks_ago(2))
      Cheer.create(sender: 'james', created_at: weeks_ago(2))
      Cheer.create(sender: 'sophie', created_at: weeks_ago(2))
      Cheer.create(sender: 'sophie', created_at: weeks_ago(2))
    end

    describe 'number of cheers grouped by week' do
      let(:cheers_by_week) { MetricsService.cheers_by_week.entries }
      it 'groups the records correctly to three groups' do
        expect(cheers_by_week.count).to eq 3
      end
      it 'orders the groups oldest first' do
        expect(unix_time_to_date(cheers_by_week[0]["date_part"])).to eq weeks_ago(2)
        expect(unix_time_to_date(cheers_by_week[1]["date_part"])).to eq weeks_ago(1)
        expect(unix_time_to_date(cheers_by_week[2]["date_part"])).to eq this_week
      end
      it 'counts the the cheers correctly per group' do
        expect(cheers_by_week[0]["count"].to_i).to eq 3
        expect(cheers_by_week[1]["count"].to_i).to eq 1
        expect(cheers_by_week[2]["count"].to_i).to eq 2
      end
    end
    describe 'number of shoutouts grouped by week' do
      let(:shoutouts_by_week) { MetricsService.shoutouts_by_week.entries }
      it 'groups the records correctly to three groups' do
        expect(shoutouts_by_week.count).to eq 3
      end
      it 'orders the groups oldest first' do
        expect(unix_time_to_date(shoutouts_by_week[0]["date_part"])).to eq weeks_ago(2)
        expect(unix_time_to_date(shoutouts_by_week[1]["date_part"])).to eq weeks_ago(1)
        expect(unix_time_to_date(shoutouts_by_week[2]["date_part"])).to eq this_week
      end
      it 'counts the the shoutouts correctly per group' do
        expect(shoutouts_by_week[0]["count"].to_i).to eq 2
        expect(shoutouts_by_week[1]["count"].to_i).to eq 1
        expect(shoutouts_by_week[2]["count"].to_i).to eq 2
      end
    end
    describe 'number of people cheering grouped by week' do
      let(:people_cheering_by_week) { MetricsService.people_cheering_by_week.entries }
      it 'groups the records correctly to three groups' do
        expect(people_cheering_by_week.count).to eq 3
      end
      it 'orders the groups oldest first' do
        expect(unix_time_to_date(people_cheering_by_week[0]["date_part"])).to eq weeks_ago(2)
        expect(unix_time_to_date(people_cheering_by_week[1]["date_part"])).to eq weeks_ago(1)
        expect(unix_time_to_date(people_cheering_by_week[2]["date_part"])).to eq this_week
      end
      it 'counts the the number of unique people cheering' do
        expect(people_cheering_by_week[0]["count"].to_i).to eq 2
        expect(people_cheering_by_week[1]["count"].to_i).to eq 1
        expect(people_cheering_by_week[2]["count"].to_i).to eq 2
      end
    end
    describe 'number of people doing shoutouts grouped by week' do
      let(:people_doing_shoutouts_by_week) { MetricsService.people_doing_shoutouts_by_week.entries }
      it 'groups the records correctly to three groups' do
        expect(people_doing_shoutouts_by_week.count).to eq 3
      end
      it 'orders the groups oldest first' do
        expect(unix_time_to_date(people_doing_shoutouts_by_week[0]["date_part"])).to eq weeks_ago(2)
        expect(unix_time_to_date(people_doing_shoutouts_by_week[1]["date_part"])).to eq weeks_ago(1)
        expect(unix_time_to_date(people_doing_shoutouts_by_week[2]["date_part"])).to eq this_week
      end
      it 'counts the the number of unique people doing shoutouts' do
        expect(people_doing_shoutouts_by_week[0]["count"].to_i).to eq 2
        expect(people_doing_shoutouts_by_week[1]["count"].to_i).to eq 1
        expect(people_doing_shoutouts_by_week[2]["count"].to_i).to eq 1
      end
    end
  end
  def this_week
    Date.today.beginning_of_week
  end
  def weeks_ago(no_of_weeks)
    Date.today.beginning_of_week - no_of_weeks.week
  end
  def unix_time_to_date(unix_time)
    DateTime.strptime(unix_time, '%s').to_date
  end
end
