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
      dob = Time.zone.now - 20.years

      navigate_to_additional_details

      choose("Passport")
      fill_in("Passport number", with: valid_document_id)
      click_button("Continue")

      expect(page).to have_content("Enter your date of birth")

      fill_in("Day", with: dob.day)
      fill_in("Month", with: dob.month)
      fill_in("Year", with: dob.year)

      click_button("Continue")

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

      expect(page).to have_content("Error: Tell us how you can prove your identity, or why you cannot.")
    end

    it "validates other identity documents field on any submission" do
      navigate_to_additional_details
      choose("I don't have any of these")
      click_button("Continue")

      expect(page).to have_content("Can you prove your identity?")

      fill_in("unaccompanied-minor-no-identification-reason-field", with: "Hello")

      click_button("Continue")

      expect(page).to have_content("Enter your date of birth")
    end
  end

  def navigate_to_additional_details
    visit "/sponsor-a-child/task-list"
    click_link("Additional details")
    expect(page).to have_content("Do you have any of these identity documents?")
  end
end
