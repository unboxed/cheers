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
    params[:text].scan(/#[0-9]+/).each do |id|
      latest.limit(1).first.delete if latest.size >= 3
      next unless (shoutout = Shoutout.find_by_id(id[1..-1]))
      if shoutout.recipients.include?(params[:user_name])
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
