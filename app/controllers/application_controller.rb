class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  def index
    @shoutouts = Shoutout.order('created_at DESC').all
  end

  def shoutout
    user = params[:user_name]
    message = params[:text]
    recipient = message.match(/@\w+/)[0]
    message.gsub!(recipient, '').strip

    shoutout = Shoutout.create(
      sender: params[:user_name],
      recipient: recipient.gsub('@', ''),
      message: message
    )

    render text: "You sent #{shoutout.message} to #{recipient}"
  end
end
