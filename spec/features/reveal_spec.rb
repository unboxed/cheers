require "rails_helper"

RSpec.feature "Reveals most cheered shoutouts" do
  specify "correctly selects top shouout" do
    shoutout1 = create(:shoutout, sender: "Jeff", message: "thx to @Bob", recipients: ["Bob"])
    shoutout2 = create(:shoutout, sender: "Chaz", message: "thx to @Kole", recipients: ["Kole"])
    shoutout3 = create(:shoutout, sender: "Dave", message: "thx to @Craig", recipients: ["Craig"])
    shoutout4 = create(:shoutout, sender: "Sam", message: "thx to @Tom", recipients: ["Tom"])
    shoutout5 = create(:shoutout, sender: "Liz", message: "thx to @Jez", recipients: ["Jez"])
    4.times { create(:cheer, sender: "Jeff", shoutout: shoutout1) }
    3.times { create(:cheer, sender: "Chaz", shoutout: shoutout2) }
    3.times { create(:cheer, sender: "Sam", shoutout: shoutout3) }
    2.times { create(:cheer, sender: "Dave", shoutout: shoutout4) }
    create(:cheer, sender: "Bill", shoutout: shoutout5)
    visit reveal_path
    expect(page).to have_content "thx to @Bob"
    expect(page).to have_content "thx to @Kole"
    expect(page).to have_content "thx to @Craig"
    expect(page).to have_content "thx to @Tom"
    expect(page).to_not have_content "thx to @Jez"
  end
end
