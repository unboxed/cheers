class UsersController < ApplicationController
  def set_location
    user = User.find_or_create_by_name(params[:user_name])
    location = params[:text].strip.downcase.split(/\s+/).first

    if user.location == location
      render text: "But you're already in #{location}?" and return
    elsif !%w(london capetown mordor).include?(location)
      render text: 'Hmm... try `london` or `capetown`' and return
    end

    user.update_attribute(:location, location)

    if (others = User.where(location: location).size - 1) == 0
      render text: "You're the first person in #{location}!"
    elsif others == 1
      render text: "You joined another in #{location}!"
    else
      render text: "You joined #{others} others in #{location}!"
    end
  end
end
