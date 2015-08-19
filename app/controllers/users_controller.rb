class UsersController < ApplicationController
  def location_missing
    render text: "Please enter `/myoffice london` or `/myoffice capetown`.
                  Then enter `/shoutout #{params[:text]}` again."
  end

  def set_location
    user = User.find_or_create_by_name(params[:user_name])
    location = params[:text].strip.downcase.split(/\s+/).first

    if user.location == location
      render text: "But you're already in #{location}?" and return
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
