class MetricsPresenter
  def cheers_by_week
    @_cheers_by_week ||= MetricsService.cheers_by_week
    format_weekly_stats(@_cheers_by_week).to_json
  end

  def shoutouts_by_week
    @_shoutouts_by_week ||= MetricsService.shoutouts_by_week
    format_weekly_stats(@_shoutouts_by_week).to_json
  end

  def people_cheering_by_week
    @_people_cheering_by_week ||= MetricsService.people_cheering_by_week
    format_weekly_stats(@_people_cheering_by_week).to_json
  end

  def people_doing_shoutouts_by_week
    @_people_doing_shoutouts_by_week ||= MetricsService.people_doing_shoutouts_by_week
    format_weekly_stats(@_people_doing_shoutouts_by_week).to_json
  end

  private
  def format_weekly_stats(weekly_stats)
    weekly_stats.map do |week|
      { x: week["date_part"].to_i, y: week["count"].to_i }
    end
  end
end
