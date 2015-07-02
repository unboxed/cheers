module ApplicationHelper
  def highlight(message, names)
    message.tap do |message|
      names.each do |name|
        message.gsub!("@#{name}", "<mark>@#{name}</mark>")
      end
    end
  end

  def time_ago_message(time)
    (distance_of_time_in_words(time, Time.zone.now))
      .gsub('about', '')
      .gsub('less than a', '1')
      .gsub(/ minutes?/, 'm')
      .gsub(/ hours?/, 'h')
      .gsub(/ days?/, 'd')
      .strip + ' ago'
  end
end
