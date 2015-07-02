class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  def index
    @shoutouts = Shoutout.order('created_at DESC').all
  end

  def shoutout
    if params[:text].strip == 'undo'
      Shoutout.undo_latest_for_user(params[:user_name])
      return render text: 'Shoutout undone!'
    end

    if params[:text].include?(params[:user_name])
      return render text: "Share the love, you can't shoutout yourself!"
    end

    shoutout = Shoutout.create(
      sender: params[:user_name],
      recipients: params[:text].scan(/@\w+/).map { |r| r[1..-1] },
      message: params[:text].strip
    )

    render text: "Shoutout to #{shoutout.recipients.join(' & ')} saved!"
  end

  def cheer
    latest = Cheer.latest_for_user(params[:user_name])

    if params[:text].strip == 'undo'
      latest.last.delete unless latest.empty?
      return render text: 'Cheer undone!'
    elsif params[:text].strip == 'clear'
      latest.delete_all
      return render text: 'Cheers cleared!'
    end

    names = []
    params[:text].scan(/#[0-9]+/).each do |id|
      latest.limit(1).first.delete if latest.size >= 3
      shoutout = Shoutout.find(id[1..-1])
      Cheer.create(sender: params[:user_name], shoutout: shoutout)
      names << shoutout.sender
    end
    render text: "You cheered for #{names.uniq.join(' & ')}!"
  end
end
