class Shoutout < ActiveRecord::Base
  has_many :cheers
  serialize :recipients
  acts_as_taggable

  def self.since_sunday_morning
    where(created_at: Date.today.beginning_of_week(:sunday)..Time.zone.now)
      .order('created_at DESC')
  end

  def self.winners_since_sunday_morning(tag = nil)
    shoutouts = tag ? since_sunday_morning.tagged_with(tag) : since_sunday_morning
    shoutouts.group_by { |s| s.cheers.size }
      .sort_by { |k, v| -k }
      .first(3)
      .map(&:last)
      .flatten
  end

  def self.winning_people_and_shoutouts(tag = nil)
    shoutouts = tag ? since_sunday_morning.tagged_with(tag) : since_sunday_morning
    winners = winning_people_for_shoutouts(shoutouts)
    winners.map do |w|
      { name: w, shoutouts: filter_for_recipient(shoutouts, w)}
    end
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

  private

  def self.winning_people_for_shoutouts(shoutouts)
    recipients = Hash.new(0)
    shoutouts.each do |shoutout|
      shoutout.recipients.each do |r|
        recipients[r] += shoutout.cheers.size
      end
    end
    recipients.select { |k, v| v == recipients.max_by { |k, v| v }[1] }.keys
  end

  def self.filter_for_recipient(shoutouts, recipient)
    shoutouts.select do |shoutout|
      shoutout.recipients.include?(recipient)
    end
  end
end
