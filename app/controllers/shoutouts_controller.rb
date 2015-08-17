class ShoutoutsController < ApplicationController
  # TODO pull credentials out into environment variables
  http_basic_authenticate_with name: 'cheerybot', password: 'share the love', only: :admin

  def index
    @shoutouts = Shoutout.since_sunday_morning
  end

  def admin
    @shoutouts = Shoutout.since_sunday_morning
      .sort_by { |s| s.cheers.size }
      .reverse
    @winning_count = @shoutouts.first.cheers.size unless @shoutouts.empty?
  end

  def reveal
    @shoutout = Shoutout.since_sunday_morning
      .sort_by { |s| s.cheers.size }
      .last
    return redirect_to root_path, flash: { error: 'No Shoutouts '} unless @shoutout
  end

  def tag
    @tag = params[:tag]
    @shoutouts = Shoutout.tagged_with(params[:tag])
  end

  def create
    if params[:text].match(/undo|clear/)
      if Shoutout.undo_latest_for_user(params[:user_name])
        return render text: 'Shoutout undone!'
      else
        return render text: 'How about doing something first? #{root_url}help'
      end
    end

    if params[:text].include?(params[:user_name])
      return render text: "Share the love, you can't shoutout yourself! #{root_url}help"
    elsif !params[:text].match(/@\w+/)
      return render text: "Share the love! You need to mention someone. #{root_url}help"
    end

    shoutout = Shoutout.create(
      sender: params[:user_name],
      recipients: params[:text]
                    .scan(/(@(\w+|\.)+)/)
                    .map(&:first).map { |r| r[1..-1] },
      message: params[:text].strip,
      tag_list: params[:text]
                    .scan(/(#(\w+)+)/)
                    .map(&:first).map { |t| t[1..-1] }.join(', ')
    )

    render text: "Shoutout to #{shoutout.recipients.join(' & ')} saved! Visit #{root_url} to see your shoutout."
  end
end
