RSpec.describe "Sponsor contact details", type: :system do
  before do
    driven_by(:rack_test_user_agent)
    application = UnaccompaniedMinor.new
    application.save!
    page.set_rack_session(app_reference: application.reference)
    navigate_to_contact_details
  end

  let(:sponsor_email) { "sponsor@example.com" }
  let(:nonmatching_sponsor_email) { "notmatching@example.com" }
  let(:phone_page_content) { "Enter your UK phone number" }

  describe "Sponsors contact details don't match" do
    it "shows error message for not matching email addresses" do
      fill_in_email_and_continue(confirm_email: nonmatching_sponsor_email)

      expect(page).to have_content("Error: Emails must match")
      expect(page).to have_field("Email", with: sponsor_email)
      expect(page).to have_field("unaccompanied_minor[email_confirm]", with: nonmatching_sponsor_email)
    end
  end

  describe "Sponsors email addresses valid" do
    it "continues to next stage" do
      fill_in_email_and_continue

      expect(page).to have_content(phone_page_content)
    end

    it "persists both email fields on round trip" do
      fill_in_email_and_continue

      expect(page).to have_content(phone_page_content)

      navigate_to_contact_details

      expect(page).to have_field("Email", with: sponsor_email)
      expect(page).to have_field("unaccompanied_minor[email_confirm]", with: sponsor_email)
    end
  end

  def navigate_to_contact_details
    visit "/sponsor-a-child/task-list"
    click_link("Contact details")

    expect(page).to have_content("Enter an email address that you have access to")
  end

  def fill_in_email_and_continue(confirm_email: sponsor_email)
    fill_in("Email", with: sponsor_email)
    fill_in("unaccompanied_minor[email_confirm]", with: confirm_email)

    click_button("Continue")
  end
end
