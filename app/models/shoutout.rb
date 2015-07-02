class Shoutout < ActiveRecord::Base
  has_many :cheers
  serialize :recipients

  def self.undo_latest_for_user(user_name)
    where(sender: user_name)
      .order('created_at DESC')
      .limit(1)
      .first
      .delete
  end
end
