require "rails_helper"

RSpec.describe "Individual expression of interest", type: :system do
  before do
    driven_by(:rack_test_user_agent)
  end

  describe "submitting the form" do
    it "saves all of the answers in the database - same property" do
      visit root_path
      expect(page).to have_content("Homes for Ukraine")
      click_link("Register your interest as an individual")

      fill_in("Enter your full name", with: "John Smith")
      click_button("Continue")

      fill_in("Enter your email address", with: "john.smith@example.com")
      click_button("Continue")

      fill_in("Enter your contact telephone number", with: "01234567890")
      click_button("Continue")

      fill_in("Address line 1", with: "House number and Street name")
      fill_in("Town", with: "Some Town or City")
      fill_in("Postcode", with: "XX1 1XX")
      click_button("Continue")

      expect(page).to have_content("Is the property you’re offering at a different address to your home?")
      choose("No")
      click_button("Continue")

      expect(page).to have_content("How many people will be living at the address you’re offering (not including guests)?")
      fill_in("Adults", with: "1")
      fill_in("Children", with: "9")
      click_button("Continue")

      expect(page).to have_content("Who would you like to offer accommodation to?")
      choose("Single adult")
      click_button("Continue")

      expect(page).to have_content("How long can you offer accommodation for?")
      choose("From 6 to 9 months")
      click_button("Continue")

      fill_in("How many single rooms do you have available in the property you have specified?", with: 3)
      click_button("Continue")

      fill_in("How many double bedrooms (or larger) do you have available in the property you have specified?", with: 2)
      click_button("Continue")

      expect(page).to have_content("Name John Smith")
      expect(page).to have_content("Email john.smith@example.com")
      expect(page).to have_content("Telephone number 01234567890")
      expect(page).to have_content("Residential address House number and Street name")
      expect(page).to have_content("Different address no")
      expect(page).to have_content("Adults 1")
      expect(page).to have_content("Children 9")
      expect(page).to have_content("Who can you accommodate? Single adult")
      expect(page).to have_content("Accommodation length From 6 to 9 months")
      expect(page).to have_content("Single rooms available 3")
      expect(page).to have_content("Double rooms available 2")

      click_button("Accept And Send")

      expect(page).to have_content("Application complete")

      application = IndividualExpressionOfInterest.order("created_at DESC").last
      expect(application.as_json).to include({
                                                 fullname: "John Smith",
                                                 email: "john.smith@example.com",
                                                 phone_number: "01234567890",
                                                 residential_line_1: "House number and Street name",
                                                 residential_town: "Some Town or City",
                                                 residential_postcode: "XX1 1XX",
                                                 different_address: "no",
                                                 number_adults: "1",
                                                 number_children: "9",
                                                 family_type: "single_adult",
                                                 accommodation_length: "from_6_to_9_months",
                                                 single_room_count: "3",
                                                 double_room_count: "2",
                                             })

      expect(application.ip_address).to eq("127.0.0.1")
      expect(application.user_agent).to eq("DummyBrowser")
      expect(application.started_at).to match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.\d*Z/)
    end

    it "saves all of the answers in the database - different property" do
      visit root_path
      expect(page).to have_content("Homes for Ukraine")
      click_link("Register your interest as an individual")

      fill_in("Enter your full name", with: "John Smith")
      click_button("Continue")

      fill_in("Enter your email address", with: "john.smith@example.com")
      click_button("Continue")

      fill_in("Enter your contact telephone number", with: "01234567890")
      click_button("Continue")

      fill_in("Address line 1", with: "House number and Street name")
      fill_in("Town", with: "Some Town or City")
      fill_in("Postcode", with: "XX1 1XX")
      click_button("Continue")

      expect(page).to have_content("Is the property you’re offering at a different address to your home?")
      choose("Yes")
      click_button("Continue")

      expect(page).to have_content("Enter the address of the property you’re offering")
      fill_in("Address line 1", with: "Property 1 House number and Street name")
      fill_in("Town", with: "Property 1 Some Town or City")
      fill_in("Postcode", with: "AA1 1AA")
      click_button("Continue")

      expect(page).to have_content("Are you offering any more properties?")
      choose("Yes")
      click_button("Continue")

      expect(page).to have_content("You will be able to share information about any more properties you have to offer when your local authority contacts you")
      click_button("Continue")

      expect(page).to have_content("How many people will be living at the address you’re offering (not including guests)?")
      fill_in("Adults", with: "1")
      fill_in("Children", with: "9")
      click_button("Continue")

      expect(page).to have_content("Who would you like to offer accommodation to?")
      choose("Single adult")
      click_button("Continue")

      expect(page).to have_content("How long can you offer accommodation for?")
      choose("From 6 to 9 months")
      click_button("Continue")

      fill_in("How many single rooms do you have available in the property you have specified?", with: 3)
      click_button("Continue")

      fill_in("How many double bedrooms (or larger) do you have available in the property you have specified?", with: 2)
      click_button("Continue")

      expect(page).to have_content("Name John Smith")
      expect(page).to have_content("Email john.smith@example.com")
      expect(page).to have_content("Telephone number 01234567890")
      expect(page).to have_content("Residential address House number and Street name")
      expect(page).to have_content("Different address yes")
      expect(page).to have_content("Property one address Property 1 House number and Street name")
      expect(page).to have_content("More properties yes")
      expect(page).to have_content("Adults 1")
      expect(page).to have_content("Children 9")
      expect(page).to have_content("Who can you accommodate? Single adult")
      expect(page).to have_content("Accommodation length From 6 to 9 months")
      expect(page).to have_content("Single rooms available 3")
      expect(page).to have_content("Double rooms available 2")

      click_button("Accept And Send")

      expect(page).to have_content("Application complete")

      application = IndividualExpressionOfInterest.order("created_at DESC").last
      expect(application.as_json).to include({
        fullname: "John Smith",
        email: "john.smith@example.com",
        phone_number: "01234567890",
        residential_line_1: "House number and Street name",
        residential_town: "Some Town or City",
        residential_postcode: "XX1 1XX",
        different_address: "yes",
        property_one_line_1: "Property 1 House number and Street name",
        property_one_town: "Property 1 Some Town or City",
        property_one_postcode: "AA1 1AA",
        more_properties: "yes",
        number_adults: "1",
        number_children: "9",
        family_type: "single_adult",
        accommodation_length: "from_6_to_9_months",
        single_room_count: "3",
        double_room_count: "2",
      })

      expect(application.ip_address).to eq("127.0.0.1")
      expect(application.user_agent).to eq("DummyBrowser")
      expect(application.started_at).to match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.\d*Z/)
    end
  end
end
