require 'rails_helper'

RSpec.describe MetricsPresenter, type: :presenter do

  describe "presenting metrics" do
    it 'presenting cheers grouped by week should call metrics service properly' do
      expect(MetricsService).to receive(:cheers_by_week) { [] }
      subject.cheers_by_week
    end
    it 'presenting shoutouts grouped by week should call metrics service properly' do
      expect(MetricsService).to receive(:shoutouts_by_week) { [] }
      subject.shoutouts_by_week
    end
    it 'presenting people cheering grouped by week should call metrics service properly' do
      expect(MetricsService).to receive(:people_cheering_by_week) { [] }
      subject.people_cheering_by_week
    end
    it 'presenting people doing soutouts grouped by week should call metrics service properly' do
      expect(MetricsService).to receive(:people_doing_shoutouts_by_week) { [] }
      subject.people_doing_shoutouts_by_week
    end
  end
end
