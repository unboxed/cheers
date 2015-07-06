class Cheer < ActiveRecord::Base
  belongs_to :shoutout

  def self.latest_for_user(user_name)
    where(sender: user_name, created_at: Date.today.beginning_of_week(:sunday)..Time.zone.now)
      .order('created_at ASC')
  end
end
