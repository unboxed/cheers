module ShoutoutsHelper
  def highlight_usernames(message, names)
    message.tap do |message|
      names.each do |name|
        message.gsub!("@#{name}", "<mark>@#{name}</mark>")
      end
    end
  end

  def time_ago_message(time)
    distance_of_time_in_words(time, Time.zone.now)
      .gsub('about', '')
      .gsub('less than a', '1')
      .gsub(/ minutes?/, 'm')
      .gsub(/ hours?/, 'h')
      .gsub(/ days?/, 'd')
      .strip + ' ago'
  end

  def format_recipients(recipients)
    list = ''
    recipients.each_with_index do |r, index|
      list += "<strong>#{r}</strong>"
      list += (index < recipients.size - 2) ? ', ' : ''
      list += (index == recipients.size - 2) ? ' & ' : ''
    end
    return list
  end

  def unique_senders_count(shoutouts)
    shoutouts.map(&:sender).uniq.size
  end

  def unique_recipients_count(shoutouts)
    shoutouts.map(&:recipients).flatten.uniq.size
  end

  def cheer_count(shoutouts)
    shoutouts.map(&:cheers).flatten.size
  end
end
