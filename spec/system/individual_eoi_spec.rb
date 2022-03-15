require "rails_helper"

RSpec.describe "Individual expression of interest", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe "submitting the form" do
    it "saves all of the answers in the database" do
      visit root_path
      expect(page).to have_content("Homes for Ukraine")
      click_link("Register your interest as an individual")

      expect(page).to have_content("Who can you accommodate?")
      choose("Single adult")
      click_button("Continue")

      expect(page).to have_content("What type of living space can you offer?")
      choose("Rooms in your home with access to shared facilities")
      click_button("Continue")

      expect(page).to have_content("Is the entire property accessible to people with mobility impairments?")
      choose("Yes, all")
      click_button("Continue")

      fill_in("How many single rooms do you have available?", with: 3)
      click_button("Continue")

      fill_in("How many double rooms do you have available?", with: 2)
      click_button("Continue")

      fill_in("Enter the postcode of the main property you’re offering (If you are offering multiple properties, please enter the first part of all the postcodes separated by a comma)", with: "SG13 7DF")
      click_button("Continue")

      expect(page).to have_content("How long can you offer accommodation?")
      choose("From 6 to 9 months")
      click_button("Continue")

      fill_in("Enter your full name", with: "John Smith")
      click_button("Continue")

      fill_in("Enter your email address", with: "john.smith@example.com")
      click_button("Continue")

      fill_in("Enter your contact telephone number", with: "0123456789")
      click_button("Continue")

      page.check("individual-expression-of-interest-agree-future-contact-true-field")
      click_button("Continue")

      page.check("individual-expression-of-interest-agree-privacy-statement-true-field")
      click_button("Continue")

      expect(page).to have_content("Who can you accommodate? Single Adult")
      expect(page).to have_content("Living space Rooms In Home Shared Facilities")
      expect(page).to have_content("Mobility impaired accessible property Yes, all")
      expect(page).to have_content("Single rooms available 3")
      expect(page).to have_content("Double rooms available 2")
      expect(page).to have_content("Property postcode(s) SG13 7DF")
      expect(page).to have_content("Accomodation length From 6 to 9 months")
      expect(page).to have_content("Name John Smith")
      expect(page).to have_content("Email john.smith@example.com")
      expect(page).to have_content("Telephone number 0123456789")
      expect(page).to have_content("Future contact Agreed")
      expect(page).to have_content("Privacy statement Agreed")

      click_button("Accept And Send")

      expect(page).to have_content("Application complete")

      application = IndividualExpressionOfInterest.order("created_at DESC").last
      expect(application.as_json).to include({
        accommodation_length: "from_6_to_9_months",
        agree_future_contact: "true",
        agree_privacy_statement: "true",
        double_room_count: "2",
        email: "john.smith@example.com",
        family_type: "single_adult",
        fullname: "John Smith",
        living_space: "rooms_in_home_shared_facilities",
        step_free: "yes_all",
        phone_number: "0123456789",
        postcode: "SG13 7DF",
        single_room_count: "3",
      })
    end
  end
end
