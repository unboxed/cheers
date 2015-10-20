require "slack"

Slack.configure do |config|
  config.token = Settings.slack.token
end

