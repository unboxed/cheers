class Cheer < ActiveRecord::Base
  belongs_to :shoutout

  def self.latest_for_user(user_name)
    where('sender = ? AND created_at >= ?', user_name, 1.week.ago)
      .order('created_at ASC')
  end
end
