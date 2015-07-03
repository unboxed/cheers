class Shoutout < ActiveRecord::Base
  has_many :cheers
  serialize :recipients

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
