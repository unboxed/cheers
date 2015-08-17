require "rails_helper"

RSpec.feature "Shouting out to another person" do
  specify "displays the shoutout message, and time on the home page" do
    response = send_shoutout(from: "Jeff", message: "thanks @Bob for all the fish")
    visit root_path
    expect(page).to have_content "thanks @Bob for all the fish"
    expect(page).to have_content "Jeff made a shoutout to Bob"
    expect(page).to have_content "1m ago"
    expect(response.body).to include("Shoutout to Bob saved! Visit http://example.org/ to see your shoutout.")
  end

  specify "responds appropriately when attempting to self shoutout" do
    response = send_shoutout(from: "Jeff", message: "thx @Jeff")
    expect(response.body).to include("Share the love, you can't shoutout yourself!")
  end

  specify "responds appropriately when no one is mentioned in message" do
    response = send_shoutout(from: "Jeff", message: "thx mate")
    expect(response.body).to include("Share the love! You need to mention someone.")
  end
end

RSpec.feature "Shouting out with tags" do
  specify "displays the shoutout message and hashtag link" do
    response = send_shoutout(from: "Jeff", message: "thanks @Chaz #london")
    visit root_path
    expect(page).to have_content "thanks @Chaz #london"
    expect(page).to have_selector(:link_or_button, '#london')
  end

  specify "displays the shoutout message on specific tag page" do
    response = send_shoutout(from: "Jeff", message: "thanks @Chaz #london")
    visit('/tag/london')
    expect(page).to have_content "thanks @Chaz #london"
    expect(page).to have_selector(:link_or_button, '#london')
  end
end

RSpec.feature "Undoing previous shoutout" do
  specify "undoes the shoutout message" do
    create(:shoutout, sender: "Jeff", message: "thx to @Bob", recipients: ["Bob"])
    response = send_shoutout(from: "Jeff", message: "undo")
    visit root_path
    expect(page).to_not have_content "thx to @Bob"
    expect(response.body).to include("Shoutout undone!")
  end

  specify "responds appropriately when no shoutout made" do
    response = send_shoutout(from: "Jeff", message: "undo")
    expect(response.body).to include("How about doing something first?")
  end
end

RSpec.feature "Revealing winning shoutout" do
  specify "redirection when no shoutouts" do
    response = get reveal_path
    expect(response.status).to be 302
  end
end

def send_shoutout(from:, message:)
  post shoutout_path, user_name: from, text: message
end
