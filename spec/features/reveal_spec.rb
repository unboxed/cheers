require "rails_helper"

RSpec.feature "Reveals most cheered shoutout" do
  specify "correctly selects top shouout" do
    shoutout1 = create(:shoutout, sender: "Jeff", message: "thx to @Bob", recipients: ["Bob"])
    shoutout2 = create(:shoutout, sender: "Chaz", message: "thx to @Kole", recipients: ["Kole"])
    2.times { create(:cheer, sender: "Jeff", shoutout: shoutout1) }
    3.times { create(:cheer, sender: "Chaz", shoutout: shoutout2) }
    visit reveal_path
    expect(page).to have_content "thx to @Kole"
  end
end
