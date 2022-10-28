require "rails_helper"

RSpec.describe "Individual expression of interest", type: :system do
  before do
    driven_by(:rack_test_user_agent)
  end

  describe "Validation" do
    it "wont let you continue on an empty name field" do
      eoi_skip_to_questions
      click_on("Continue")

      expect(page).to have_content("Error: You must enter your full name")
    end

    it "won't let you enter just one name" do
      eoi_skip_to_questions
      fill_in("Enter your full name", with: "Tim")
      click_on("Continue")

      expect(page).to have_content("Error: You must enter your full name")
    end

    it "won't let you continue on an empty email field" do
      eoi_skip_to_questions
      eoi_enter_sponsor_name
      click_on("Continue")

      expect(page).to have_content("Error: You must enter a valid email address")
    end

    it "stops progression on an invalid email address" do
      eoi_skip_to_questions
      eoi_enter_sponsor_name
      fill_in("Enter your email address", with: "Notanemail.com")
      click_on("Continue")

      expect(page).to have_content("Error: You must enter a valid email address")
    end

    it "validates empty field for phone number" do
      eoi_skip_to_questions
      eoi_enter_sponsor_name
      fill_in("Enter your email address", with: "test@test.com")
      click_on("Continue")
      click_on("Continue")

      expect(page).to have_content("Enter your contact telephone number")
      expect(page).to have_content("Error: You must enter a valid phone number")
    end

    it "won't allow you to continue on an invalid phone number" do
      eoi_skip_to_questions
      eoi_enter_sponsor_name
      fill_in("Enter your email address", with: "test@test.com")
      click_on("Continue")
      fill_in("Enter your contact telephone number", with: "00123")
      click_on("Continue")

      expect(page).to have_content("Enter your contact telephone number")
      expect(page).to have_content("Error: You must enter a valid phone number")
    end

    it "won't allow you to continue if the first line of the address isn't present" do
      eoi_skip_to_questions
      eoi_enter_sponsor_name
      eoi_enter_sponsor_contact_details
      eoi_enter_address(line1: "", town: "HouseTown", postcode: "CH1 1LD")

      expect(page).to have_content("Error: You must enter an address")
    end

    it "won't allow you to continue if the address town or city isn't present" do
      eoi_skip_to_questions
      eoi_enter_sponsor_name
      eoi_enter_sponsor_contact_details
      eoi_enter_address(line1: "HouseTown", town: "", postcode: "CH1 1LD")

      expect(page).to have_content("Error: You must enter a town or city")
    end

    it "won't allow you to continue if the address postcode isn't present" do
      eoi_skip_to_questions
      eoi_enter_sponsor_name
      eoi_enter_sponsor_contact_details
      eoi_enter_address(line1: "HouseTown", town: "CHILD", postcode: "")

      expect(page).to have_content("Error: You must enter a valid UK postcode")
    end

    it "won't allow no choice on different address question" do
      eoi_skip_to_questions
      eoi_enter_sponsor_name
      eoi_enter_sponsor_contact_details
      eoi_enter_address
      click_on("Continue")

      expect(page).to have_content("Error: You must select an option to continue")
    end

    it "won't allow no first line on different address question" do
      eoi_skip_to_questions
      eoi_enter_sponsor_name
      eoi_enter_sponsor_contact_details
      eoi_enter_address
      eoi_choose_option("Yes")
      eoi_enter_address(line1: "", town: "DifferentTown", postcode: "XX1 1LD")

      expect(page).to have_content("Error: You must enter an address")
    end

    it "won't allow no town on different address question" do
      eoi_skip_to_questions
      eoi_enter_sponsor_name
      eoi_enter_sponsor_contact_details
      eoi_enter_address
      eoi_choose_option("Yes")
      eoi_enter_address(line1: "Street1", town: "", postcode: "XX1 1LD")

      expect(page).to have_content("Error: You must enter a town or city")
    end

    it "won't allow no postcode on different address question" do
      eoi_skip_to_questions
      eoi_enter_sponsor_name
      eoi_enter_sponsor_contact_details
      eoi_enter_address
      eoi_choose_option("Yes")
      eoi_enter_address(line1: "Street1", town: "DifferentTown", postcode: "")

      expect(page).to have_content("Error: You must enter a valid UK postcode")
    end
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

      click_link("Change different address")

      expect(page).to have_content("Is the property you’re offering at a different address to your home?")

      choose("Yes")
      click_button("Continue")

      expect(page).to have_content("Name Spencer Graham")
      expect(page).to have_content("Email spencer.sponsor@example.com")
      expect(page).to have_content("Telephone number 07123123123")
      expect(page).to have_content("Residential address Address line 1 Town XX1 1XX")
      expect(page).to have_content("Different address Yes")
      expect(page).to have_content("How many adults 2")
      expect(page).to have_content("How many children 3")
      expect(page).to have_content("Who can you accommodate? Single adult")
      expect(page).to have_content("Single bedrooms available 6")
      expect(page).to have_content("Double bedrooms available 3")
      expect(page).to have_content("Step-free access Yes, all")
      expect(page).to have_content("Allow pets Yes")
      expect(page).to have_content("User research Yes")
      expect(page).to have_content("Privacy statement Agreed")

      click_button("Accept and send")

      expect(page).to have_content("Thank you for registering")
    end
  end
end
