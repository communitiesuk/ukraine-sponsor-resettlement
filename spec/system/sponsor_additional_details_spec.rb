require "rails_helper"
require "securerandom"

RSpec.describe "Sponsor additional details", type: :system do
  before do
    driven_by(:rack_test_user_agent)
  end

  describe "adding sponsors additional details" do
    let(:valid_document_id) { "123123123" }
    let(:task_list_content) { "Apply for approval to provide a safe home for a child from Ukraine" }
    let(:dob) { Time.zone.now - 20.years }

    before do
      application = UnaccompaniedMinor.new
      application.save!
      page.set_rack_session(app_reference: application.reference)
    end

    it "retains all additional details when page is reloaded" do
      navigate_to_additional_details

      uam_enter_sponsor_identity_documents("Passport")

      expect(page).to have_content("Enter your date of birth")

      uam_fill_in_date_of_birth(dob)

      uam_enter_sponsor_nationalities(nationality: "Denmark")

      expect(page).to have_content(task_list_content)

      navigate_to_additional_details

      passport_value = find_field("unaccompanied_minor[passport_identification_number]").value
      expect(passport_value).to eq(valid_document_id)

      click_button("Continue")

      expect(page).to have_field("Day", with: dob.day)
      expect(page).to have_field("Month", with: dob.month)
      expect(page).to have_field("Year", with: dob.year)
    end

    it "validates other identity documents field on blank submission" do
      navigate_to_additional_details
      choose("I don't have any of these")
      click_button("Continue")

      expect(page).to have_content("Can you prove your identity?")

      click_button("Continue")

      expect(page).to have_content("There is a problem")
      expect(page).to have_content("Error: Tell us how you can prove your identity, or why you cannot.")
    end

    it "if reason is entered for no identity documents it allows user to continue" do
      navigate_to_additional_details
      uam_enter_sponsor_identity_documents("I don't have any of these")

      expect(page).to have_content("Enter your date of birth")
    end

    it "enforces that nationality is mandatory" do
      navigate_to_nationality

      click_button("Continue")

      expect(page).to have_content("There is a problem")
      expect(page).to have_content("Error: You must select a valid nationality")
    end
  end

  def navigate_to_additional_details
    visit "/sponsor-a-child/task-list"
    click_link("Additional details")
    expect(page).to have_content("Do you have any of these identity documents?")
  end

  def navigate_to_nationality
    navigate_to_additional_details

    choose("Passport")
    fill_in("Passport number", with: "123456789")
    click_button("Continue")

    fill_in("Day", with: "6")
    fill_in("Month", with: "11")
    fill_in("Year", with: "1987")
    click_button("Continue")
    expect(page).to have_content("Enter your nationality")
  end
end
