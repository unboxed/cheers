class Admin::HomeController < Admin::BaseController
  def index
    @shoutouts = Shoutout.since_sunday_morning
      .sort_by { |s| s.cheers.size }
      .reverse
    @winning_count = @shoutouts.first.cheers.size unless @shoutouts.empty?
  end
end
