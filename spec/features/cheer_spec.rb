require "rails_helper"

RSpec.feature "Cheering for shoutouts" do
  specify "changes cheer count" do
    shoutout = create(:shoutout)
    response = send_cheer(from: "Jeff", text: "##{shoutout.id}")
    expect(shoutout.cheers.size).to be 1
    expect(response.body).to eq "Hip Hip! You cheered for Bob!"
  end

  specify "responds appropriately to invalid cheer command input" do
    response = send_cheer(from: "Jeff", text: "voting")
    expect(response.body).to eq "Woah there, how about making some valid cheers next time?"
  end

  specify "responds appropriately to self cheering" do
    shoutout = create(:shoutout, message: "thanks @Bob")
    response = send_cheer(from: "Bob", text: "##{shoutout.id}")
    expect(response.body).to eq "Cheeky! There are other ways to rig this election!"
  end
end

RSpec.feature "Undoing and clearing cheers" do
  specify "/cheer undo should delete latest cheer" do
    shoutout = create(:shoutout)
    3.times do
      create(:cheer, sender: "Jeff", shoutout: shoutout)
    end
    response = send_cheer(from: "Jeff", text: "undo")
    expect(shoutout.cheers.size).to be 2
    expect(response.body).to eq "Cheer undone!"
  end

  specify "/cheer clear should delete all recent cheers" do
    shoutout = create(:shoutout)
    3.times do
      create(:cheer, sender: "Jeff", shoutout: shoutout)
    end
    response = send_cheer(from: "Jeff", text: "clear")
    expect(shoutout.cheers.size).to be 0
    expect(response.body).to eq "Cheers cleared!"
  end
end

def send_cheer(from:, text:)
  post "/cheer", user_name: from, text: text
end

