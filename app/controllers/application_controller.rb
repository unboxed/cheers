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

  def cheer
    params[:text].scan(/#[0-9]+/).each do |id|
      past = Cheer
        .where('sender = ? AND created_at >= ?', params[:user_name], 1.week.ago)
        .order('created_at ASC')
      past.limit(1).first.delete if past.size >= 3
      Cheer.create(sender: params[:user_name], shoutout: Shoutout.find(id[1..-1]))
    end
    render text: params[:text].scan(/#[0-9]+/)
  end
end
