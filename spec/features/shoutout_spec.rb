require "rails_helper"

RSpec.feature "Shouting out to another person" do

  specify "displays the shoutout message, and time on the home page" do
    response = send_shoutout(from: "Jeff", message: "thanks @Bob for all the fish")
    visit root_path
    expect(page).to have_content "thanks @Bob for all the fish"
    expect(page).to have_content "Jeff made a shoutout to Bob"
    expect(page).to have_content "1m ago"
    expect(response.body).to eq "Shoutout to Bob saved!"
  end
end

def send_shoutout(from:, message:)
  post "/", user_name: from, text: message
end
