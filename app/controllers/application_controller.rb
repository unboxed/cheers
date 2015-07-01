class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  def index
    @shoutouts = Shoutout.order('created_at DESC').all
  end

  def shoutout
    user = params[:user_name]
    message = params[:text]

    recipient = message.match(/^@\w+/)
    if recipient.nil?
      return render text: "Please supply a username (with @)"
    end
    message = message.gsub(recipient[0], '').strip

    shoutout = Shoutout.create(
      sender: params[:user_name],
      recipient: recipient[0].gsub('@', ''),
      message: message
    )

    render text: "You sent #{shoutout.message} to #{recipient[0]}"
  end
end
