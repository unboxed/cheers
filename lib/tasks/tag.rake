require_relative '../../config/environment'

task :add_tag_to_shoutouts_from_week, [:tag] do |t, args|
  Shoutout.since_sunday_morning.each do |shoutout|
    next if shoutout.message.include?("##{args[:tag]}")
    message = shoutout.message + " ##{args[:tag]}"
    tag_list = message.scan(/(#(\w+)+)/)
                 .map(&:first)
                 .map { |t| t[1..-1] }
                 .join(', ')
    shoutout.update_attributes(tag_list: tag_list, message: message)
  end
end
