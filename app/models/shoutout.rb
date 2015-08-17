class Shoutout < ActiveRecord::Base
  has_many :cheers
  serialize :recipients
  acts_as_taggable

  def self.since_sunday_morning
    where(created_at: Date.today.beginning_of_week(:sunday)..Time.zone.now)
      .order('created_at DESC')
  end

  def self.winners_since_sunday_morning
    since_sunday_morning
      .group_by { |s| s.cheers.size }
      .sort_by { |k, v| -k }
      .first(3)
      .map(&:last)
      .flatten
  end

  def self.undo_latest_for_user(user_name)
    shoutouts = where(sender: user_name)
      .order('created_at DESC')
    if shoutouts.empty?
      return false
    else
      shoutouts.first.cheers.delete_all
      shoutouts.first.delete
      return true
    end
  end
end
