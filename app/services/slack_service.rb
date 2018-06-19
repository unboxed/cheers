class SlackService
  def initialize(client = Slack::Client.new)
    @client = client
  end

  def post_message(channel, message)
    @client.chat_postMessage(channel: channel, text: message, as_user: true)
  end

  def post_direct_message(token, users, message)
    members = @client.users_list(token: token)
    user_id_array = []
    members["members"].each do |key, value|
      users.each { |user| user_id_array << key["id"] if key["name"] == user }
    end
    user_id_array.each { |id| post_message(id, message) }
  end
end
