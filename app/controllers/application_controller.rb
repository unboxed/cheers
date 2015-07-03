class ApplicationController < ActionController::Base
  http_basic_authenticate_with name: 'cheerybot', password: 'share the love', only: :admin
  protect_from_forgery with: :null_session

  def index
    @shoutouts = Shoutout.order('created_at DESC').all
  end

  def admin
    @shoutouts = Shoutout.order('created_at DESC').all
      .sort_by { |s| s.cheers.size }
      .reverse
    @winning_count = @shoutouts.first.cheers.size
  end

  def shoutout
    if params[:text].match(/undo|clear/)
      if Shoutout.undo_latest_for_user(params[:user_name])
        return render text: 'Shoutout undone!'
      else
        return render text: 'How about doing something first?'
      end
    end

    if params[:text].include?(params[:user_name])
      return render text: "Share the love, you can't shoutout yourself!"
    elsif !params[:text].match(/@\w+/)
      return render text: 'Share the love! You need to mention someone.'
    end

    shoutout = Shoutout.create(
      sender: params[:user_name],
      recipients: params[:text]
                    .scan(/(@(\w+|\.)+)/)
                    .map(&:first).map { |r| r[1..-1] },
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
      next unless (shoutout = Shoutout.find_by_id(id[1..-1]))
      if shoutout.sender == params[:user_name]
        return render text: 'Cheeky! There are other ways to rig this election!'
      end
      Cheer.create(sender: params[:user_name], shoutout: shoutout)
      names << shoutout.recipients
    end
    if names.empty?
      render text: "Woah there, how about making some valid cheers next time?"
    else
      render text: "Hip Hip! You cheered for #{names.uniq.join(' & ')}!"
    end
  end
end
