require "rails_helper"
require "securerandom"

RSpec.describe "Sponsor additional details", type: :system do
  before do
    driven_by(:rack_test_user_agent)
  end

  describe "adding sponsors additional details" do
    let(:valid_document_id) { "SomeValidId123456".freeze }

    before do
      application = UnaccompaniedMinor.new
      application.save!
      page.set_rack_session(app_reference: application.reference)
    end

    it "retains date of birth when page is reloaded" do
      visit "/sponsor-a-child/task-list"
      click_link("Additional details")
      expect(page).to have_content("Do you have any of these identity documents?")

      choose("Passport")
      fill_in("Passport number", with: valid_document_id)
      click_button("Continue")

      expect(page).to have_content("Enter your date of birth")
      fill_in("Day", with: "1")
      fill_in("Month", with: "1")
      fill_in("Year", with: "2000")
      click_button("Continue")

      visit "/sponsor-a-child/task-list"
      click_link("Additional details")
      expect(page).to have_content("Do you have any of these identity documents?")
      click_button("Continue")

      expect(page).to have_field("Day", with: "1")
      expect(page).to have_field("Month", with: "1")
      expect(page).to have_field("Year", with: "2000")
    end
  end
end
