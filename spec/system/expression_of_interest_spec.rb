require "rails_helper"

RSpec.describe "Expression of interest", type: :system do
  before do
    driven_by(:rack_test_user_agent)
  end

  describe "check answers" do
    it "displays answers when the form is complete" do
      eoi_skip_to_questions
      eoi_enter_sponsor_name
      eoi_enter_sponsor_contact_details
      eoi_enter_sponsor_address
      eoi_enter_sponsor_start(asap: true)
      eoi_people_at_address
      eoi_sponsor_refugee_preference
      eoi_number_of_rooms
      eoi_accessibility_info
      eoi_contact_consent

      expect(page).to have_content("Name Spencer Graham")
      expect(page).to have_content("Email spencer.sponsor@example.com")
      expect(page).to have_content("Telephone number 07123123123")
      expect(page).to have_content("Residential address Address line 1 Town XX1 1XX")
      expect(page).to have_content("Different address No")
      expect(page).to have_content("How many adults 2")
      expect(page).to have_content("How many children 3")
      expect(page).to have_content("Who can you accommodate? Single adult")
      expect(page).to have_content("Single bedrooms available 6")
      expect(page).to have_content("Double bedrooms available 3")
      expect(page).to have_content("Step-free access Yes, all")
      expect(page).to have_content("Allow pets Yes")
      expect(page).to have_content("User research Yes")
      expect(page).to have_content("Privacy statement Agreed")
    end

    it "updates info when changed and redirects to the check answers page after" do
      eoi_skip_to_questions
      eoi_enter_sponsor_name
      eoi_enter_sponsor_contact_details
      eoi_enter_sponsor_address
      eoi_enter_sponsor_start(asap: true)
      eoi_people_at_address
      eoi_sponsor_refugee_preference
      eoi_number_of_rooms
      eoi_accessibility_info
      eoi_contact_consent

      expect(page).to have_content("Name Spencer Graham")
      expect(page).to have_content("Email spencer.sponsor@example.com")
      expect(page).to have_content("Telephone number 07123123123")
      expect(page).to have_content("Residential address Address line 1 Town XX1 1XX")
      expect(page).to have_content("Different address No")
      expect(page).to have_content("How many adults 2")
      expect(page).to have_content("How many children 3")
      expect(page).to have_content("Who can you accommodate? Single adult")
      expect(page).to have_content("Single bedrooms available 6")
      expect(page).to have_content("Double bedrooms available 3")
      expect(page).to have_content("Step-free access Yes, all")
      expect(page).to have_content("Allow pets Yes")
      expect(page).to have_content("User research Yes")
      expect(page).to have_content("Privacy statement Agreed")

      click_link("Change pet")

      expect(page).to have_content("Would you consider allowing guests to bring their pets?")

      choose("No")
      click_button("Continue")

      expect(page).to have_content("Name Spencer Graham")
      expect(page).to have_content("Email spencer.sponsor@example.com")
      expect(page).to have_content("Telephone number 07123123123")
      expect(page).to have_content("Residential address Address line 1 Town XX1 1XX")
      expect(page).to have_content("Different address No")
      expect(page).to have_content("How many adults 2")
      expect(page).to have_content("How many children 3")
      expect(page).to have_content("Who can you accommodate? Single adult")
      expect(page).to have_content("Single bedrooms available 6")
      expect(page).to have_content("Double bedrooms available 3")
      expect(page).to have_content("Step-free access Yes, all")
      expect(page).to have_content("Allow pets No")
      expect(page).to have_content("User research Yes")
      expect(page).to have_content("Privacy statement Agreed")

      click_button("Accept and send")

      expect(page).to have_content("Thank you for registering")
    end
  end
end
