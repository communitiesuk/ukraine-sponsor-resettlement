require "rails_helper"
require "securerandom"

RSpec.describe "Sponsor additional details", type: :system do
  before do
    driven_by(:rack_test_user_agent)
    application = UnaccompaniedMinor.new
    application.save!
    page.set_rack_session(app_reference: application.reference)
  end

  describe "Sponsors contact details don't match" do
    it "shows error message for not matching email addresses" do
      navigate_to_contact_details
      fill_in("Email", with: "sponsor@email.com")
      fill_in("unaccompanied-minor-email-confirm-field", with: "sponsor@email.co.uk")
      click_button("Continue")
      expect(page).to have_content("Error: Emails must match")
    end
  end

  def navigate_to_contact_details
    visit "/sponsor-a-child/task-list"
    click_link("Contact details")
    expect(page).to have_content("Enter an email address that you have access to")
  end
end
