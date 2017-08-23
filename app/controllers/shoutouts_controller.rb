class ShoutoutsController < ApplicationController
  def index
    @shoutouts = Shoutout.since_sunday_morning
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

    recipients = params[:text]
                    .scan(/(@(\w+|\.)+)/)
                    .map(&:first).map { |r| r[1..-1] }
    if (recipients.include?(params[:user_name]))
      return render text: "Share the love, you can't cheer for yourself! #{root_url}help"
    elsif !params[:text].match(/@\w+/)
      return render text: "Share the love! You need to mention someone. #{root_url}help"
    end

    message = params[:text].strip + " ##{user.location}"

    shoutout = Shoutout.create(
      sender: params[:user_name],
      message: message,
      recipients: recipients,
      tag_list: message
                  .scan(/(#(\w+)+)/)
                  .map(&:first).map { |t| t[1..-1] }.join(', ')
    )

    if shoutout.tag_list.include?("london")
      slack.post_message(Settings.slack.london, cheered_notification_message_for_channel(message))
    end

    if shoutout.tag_list.include?("capetown")
      slack.post_message(Settings.slack.cape_town, cheered_notification_message_for_channel(message))
    end

    render text: "You cheered for #{shoutout.recipients.join(' & ')}! Visit #{root_url} to see your cheer."
  end

  private

  def cheered_notification_message_for_channel(message)
    "@#{params[:user_name]} cheered: #{message}\nSee it, and other cheers at #{root_url}!"
  end

  def slack
    @_slack ||= SlackService.new
  end
end
