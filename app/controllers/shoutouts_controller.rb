class ShoutoutsController < ApplicationController
  http_basic_authenticate_with name: Settings.admin.username, password: Settings.admin.password, only: :admin

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
    @shoutouts = Shoutout.winners_since_sunday_morning(params[:tag])
    @winners = Shoutout.winning_people_and_shoutouts(params[:tag])
    return redirect_to root_path, flash: { error: 'No Shoutouts '} if @shoutouts.empty?
  end

  def tag
    @tag = params[:tag]
    @shoutouts = Shoutout.since_sunday_morning
      .tagged_with(params[:tag])
      .order('created_at DESC')
  end

  def create
    unless (user = User.find_or_create_by_name(params[:user_name])).location
      render text: [
        "Please enter `/myoffice london` or `/myoffice capetown`.",
        "Then enter `/shoutout #{params[:text]}` again."
      ].join("\n") and return
    end

    if params[:text].match(/undo|clear/)
      if Shoutout.undo_latest_for_user(params[:user_name])
        return render text: 'Cheer undone!'
      else
        return render text: "How about doing something first? #{root_url}help"
      end
    end

    if params[:text].include?(params[:user_name])
      return render text: "Share the love, you can't cheer for yourself! #{root_url}help"
    elsif !params[:text].match(/@\w+/)
      return render text: "Share the love! You need to mention someone. #{root_url}help"
    end

    message = params[:text].strip + " ##{user.location}"

    shoutout = Shoutout.create(
      sender: params[:user_name],
      message: message,
      recipients: message
                    .scan(/(@(\w+|\.)+)/)
                    .map(&:first).map { |r| r[1..-1] },
      tag_list: message
                  .scan(/(#(\w+)+)/)
                  .map(&:first).map { |t| t[1..-1] }.join(', ')
    )

    render text: "You cheered for #{shoutout.recipients.join(' & ')}! Visit #{root_url} to see your cheer."
  end
end
