class MetricsService
  SQL_NUMBER_OF_CHEERS_GROUPED_BY_WEEK =
    "SELECT EXTRACT(EPOCH FROM date_trunc('week', created_at)), count(*) FROM cheers GROUP BY 1 ORDER BY 1;"
  SQL_NUMBER_OF_PEOPLE_CHEERING_GROUPED_BY_WEEK =
    "SELECT EXTRACT(EPOCH FROM date_trunc('week', created_at)), count(distinct(sender)) FROM cheers GROUP BY 1 ORDER BY 1;"
  SQL_NUMBER_OF_SHOUTOUTS_GROUPED_BY_WEEK =
    "SELECT EXTRACT(EPOCH FROM date_trunc('week', created_at)), count(*) FROM shoutouts GROUP BY 1 ORDER BY 1;"
  SQL_NUMBER_OF_PEOPLE_DOING_SHOUTOUTS_GROUPED_BY_WEEK =
    "SELECT EXTRACT(EPOCH FROM date_trunc('week', created_at)), count(distinct(sender)) FROM shoutouts GROUP BY 1 ORDER BY 1;"

  def self.cheers_by_week
    ActiveRecord::Base.connection.execute(SQL_NUMBER_OF_CHEERS_GROUPED_BY_WEEK)
  end

  def self.people_cheering_by_week
    ActiveRecord::Base.connection.execute(SQL_NUMBER_OF_PEOPLE_CHEERING_GROUPED_BY_WEEK)
  end

  def self.shoutouts_by_week
    ActiveRecord::Base.connection.execute(SQL_NUMBER_OF_SHOUTOUTS_GROUPED_BY_WEEK)
  end

  def self.people_doing_shoutouts_by_week
    ActiveRecord::Base.connection.execute(SQL_NUMBER_OF_PEOPLE_DOING_SHOUTOUTS_GROUPED_BY_WEEK)
  end
end
