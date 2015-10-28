require "rails_helper"

RSpec.feature "Reviewing shoutouts in the admin area" do
  specify "the shoutouts are correctly displayed" do
    shoutout1 = create(:shoutout, sender: "Jeff", message: "thx to @Bob", recipients: ["Bob"])
    shoutout2 = create(:shoutout, sender: "Chaz", message: "thx to @Kole", recipients: ["Kole"])
    2.times { create(:cheer, sender: "Jeff", shoutout: shoutout1) }
    3.times { create(:cheer, sender: "Chaz", shoutout: shoutout2) }

    page.driver.browser.basic_authorize(Settings.admin.username, Settings.admin.password)
    visit admin_root_path

    expect(page.text).to match(/thx to @Kole.*thx to @Bob/)
    expect(page).to have_content "🎉3"
  end
  specify "shows a link to metrics view in admin pages" do
    page.driver.browser.basic_authorize(Settings.admin.username, Settings.admin.password)
    visit admin_root_path
    expect(page).to have_link("Metrics")
  end
  specify "displays the metrics page" do
    page.driver.browser.basic_authorize(Settings.admin.username, Settings.admin.password)
    visit admin_metrics_path
    expect(page).to have_text("Metrics")
  end
end
