require "rails_helper"

RSpec.feature "Cheering for shoutouts" do
  specify "changes cheer count" do
    shoutout = create(:shoutout)
    response = send_cheer(from: "Jeff", text: "##{shoutout.id}")
    expect(shoutout.cheers.size).to be 1
    expect(response.body).to eq "Hip Hip! You cheered for Bob!"
  end
end

def send_cheer(from:, text:)
  post "/cheer", user_name: from, text: text
end

