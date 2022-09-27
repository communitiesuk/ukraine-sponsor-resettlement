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
  let(:task_list_content) { "Apply for approval to provide a safe home for a child from Ukraine" }

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

  describe "Sponsors phone number" do
    let(:valid_phone_number) { "07123123123" }

    it "shows an error when the phone number confirmation does not match" do
      non_matching_number = "07123999999"

      fill_in_email_and_continue
      expect(page).to have_content(phone_page_content)
      fill_in_phone_numbers_and_continue(phone_number_confirm: non_matching_number)

      expect(page).to have_content("Error: Phone numbers must match")
      expect(page).to have_field("unaccompanied-minor-phone-number-field", with: valid_phone_number)
      expect(page).to have_field("Confirm phone number", with: non_matching_number)
    end

    it "does not error for confirmation mismatch when number is invalid" do
      fill_in_email_and_continue
      expect(page).to have_content(phone_page_content)
      fill_in_phone_numbers_and_continue(phone_number: "Hello", phone_number_confirm: "07123999999")

      expect(page).to have_content("Error: You must enter a valid phone number")
      expect(page).not_to have_content("Error: Phone numbers must match")
    end

    it "persists both phone number fields on round trip" do
      fill_in_email_and_continue
      expect(page).to have_content(phone_page_content)
      fill_in_phone_numbers_and_continue
      navigate_to_contact_details
      click_button("Continue")

      expect(page).to have_content(phone_page_content)
      expect(page).to have_field("unaccompanied-minor-phone-number-field", with: valid_phone_number)
      expect(page).to have_field("Confirm phone number", with: valid_phone_number)
    end

    it "validates that the phone number is UK" do
      fill_in_email_and_continue
      expect(page).to have_content(phone_page_content)

      fill_in_phone_numbers_and_continue(phone_number: "12312312312", phone_number_confirm: "12312312312")
      expect(page).to have_content("Error: You must enter a UK mobile number")
    end

    it "recognises UK mobile number with 447 rather than 07" do
      fill_in_email_and_continue
      expect(page).to have_content(phone_page_content)

      fill_in_phone_numbers_and_continue(phone_number: "447312312312", phone_number_confirm: "447312312312")
      expect(page).to have_content(task_list_content)
    end

    it "recognises UK mobile number with +447 rather than 07" do
      fill_in_email_and_continue
      expect(page).to have_content(phone_page_content)

      fill_in_phone_numbers_and_continue(phone_number: "+447312312312", phone_number_confirm: "+447312312312")
      expect(page).to have_content(task_list_content)
    end

    def fill_in_phone_numbers_and_continue(phone_number: valid_phone_number, phone_number_confirm: valid_phone_number)
      fill_in("unaccompanied-minor-phone-number-field", with: phone_number)
      fill_in("Confirm phone number", with: phone_number_confirm)

      click_button("Continue")
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
