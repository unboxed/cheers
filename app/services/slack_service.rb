class SlackService
  def initialize(client = Slack::Client.new)
    @client = client
  end
  def post_message(channel, message)
    @client.chat_postMessage(channel: channel, text: message, as_user: true)
  end
end
