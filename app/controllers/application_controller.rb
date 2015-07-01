class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  def index
    @shoutouts = Shoutout.order('created_at DESC').all
  end

  def shoutout
    return undo if params[:text].strip == 'undo'
    if (recipient = params[:text].match(/^@\w+/)).nil?
      return render text: "Please supply a username (with @)"
    else
      recipient = recipient[0]
    end

    message = params[:text].gsub(recipient, '').strip

    shoutout = Shoutout.create(
      sender: params[:user_name],
      recipient: recipient.gsub(/\W/, '').strip,
      message: message
    )

    render text: "You sent #{shoutout.message} to #{recipient}"
  end

  def undo
    Shoutout.where(sender: params[:user_name])
      .order('created_at DESC')
      .limit(1)
      .first
      .delete
    render text: "Shoutout undone!"
  end
end
