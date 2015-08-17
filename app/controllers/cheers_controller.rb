class CheersController < ApplicationController
  def create
    latest = Cheer.latest_for_user(params[:user_name])

    if params[:text].strip == 'undo'
      latest.last.delete unless latest.empty?
      return render text: 'Cheer undone!'
    elsif params[:text].strip == 'clear'
      latest.delete_all
      return render text: 'Cheers cleared!'
    end

    names = []
    params[:text].scan(/#[0-9]+/).take(3).each do |id|
      next unless (shoutout = Shoutout.find_by_id(id[1..-1]))
      if shoutout.recipients.include?(params[:user_name])
        return render text: 'Cheeky! There are other ways to rig this election! #{root_url}help'
      end

      latest[0..-3].map(&:delete)

      Cheer.create(sender: params[:user_name], shoutout: shoutout)
      latest = Cheer.latest_for_user(params[:user_name])
      names << shoutout.recipients
    end
    if names.empty?
      render text: "Woah there, how about making some valid cheers next time? See #{root_url}help"
    else
      render text: "Hip Hip! You cheered for #{names.uniq.join(' & ')}!"
    end
  end
end
