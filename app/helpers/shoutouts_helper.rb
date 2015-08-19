module ShoutoutsHelper
  def highlight_usernames(message, names)
    message.tap do |message|
      names.each do |name|
        message.gsub!("@#{name}", "<mark>@#{name}</mark>")
      end
    end
  end

  def highlight_tags(message, tags)
    message.tap do |message|
      tags.each do |tag|
        message.gsub!("##{tag}", "<a href=\"/tag/#{tag}\">##{tag}</a>")
      end
    end
  end

  def draw_emoji(message)
    message.tap do |message|
      message.scan(/:\w+:/).each do |emoji_alias|
        if emoji = Emoji.find_by_alias(emoji_alias[1..-2])
          message.gsub!(emoji_alias, emoji.raw)
        end
      end
    end
  end

  def highlight(message, names, tags)
    highlight_usernames(message, names)
    highlight_tags(message, tags)
    draw_emoji(message)
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
