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

    if params[:text].include?(params[:user_name])
      return render text: "Share the love, you can't shoutout yourself!"
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
    render text: 'Shoutout undone!'
  end

  def cheer
    if params[:text].strip == 'undo'
      latest = Cheer.latest_for_user(params[:user_name])
      latest.last.delete unless latest.empty?
      return render text: 'Cheer undone!'
    end

    names = []
    params[:text].scan(/#[0-9]+/).each do |id|
      latest = Cheer.latest_for_user(params[:user_name])
      latest.limit(1).first.delete if latest.size >= 3
      shoutout = Shoutout.find(id[1..-1])
      Cheer.create(sender: params[:user_name], shoutout: shoutout)
      names << shoutout.sender
    end
    render text: "You cheered for #{names.uniq.join(' & ')}!"
  end
end
