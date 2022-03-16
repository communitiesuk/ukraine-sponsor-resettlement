require "rails_helper"

RSpec.describe "Organisation expression of interest", type: :system do
  before do
    driven_by(:rack_test_user_agent)
  end

  describe "submitting the form" do
    it "saves all of the answers in the database" do
      visit root_path
      expect(page).to have_content("Homes for Ukraine")
      click_link("Register your interest as an organisation")

      expect(page).to have_content("Who would you like to offer accommodation to?")
      choose("Single adult")
      click_button("Continue")

      expect(page).to have_content("What type of living space can you offer?")
      choose("Room(s) in a property with access to shared facilities (bathroom and kitchen)")
      click_button("Continue")

      expect(page).to have_content("Does the property, or any of the properties, have step-free access?")
      choose("Yes, some")
      click_button("Continue")

      fill_in("How many properties do you have available?", with: 3)
      click_button("Continue")

      fill_in("How many single bedrooms do you have available?", with: 2)
      click_button("Continue")

      fill_in("How many double bedrooms (or larger) do you have available?", with: 1)
      click_button("Continue")

      fill_in("Enter the first half of the postcode of the property you’re offering. (If you are offering multiple properties, please enter all the postcodes separated by a comma)", with: "SG13, SG12")
      click_button("Continue")

      fill_in("Enter your organisation name", with: "My Organisation Name")
      click_button("Continue")

      expect(page).to have_content("Enter your organisation type")
      choose("Charity")
      click_button("Continue")

      expect(page).to have_content("Can we contact you about your registration?")
      page.check("organisation-expression-of-interest-agree-future-contact-true-field")
      click_button("Continue")

      fill_in("Enter your full name", with: "John Smith")
      click_button("Continue")

      fill_in("Enter your email address", with: "john.smith@example.com")
      click_button("Continue")

      fill_in("Enter your contact telephone number", with: "0123456789")
      click_button("Continue")

      page.check("organisation-expression-of-interest-agree-privacy-statement-true-field")
      click_button("Continue")

      expect(page).to have_content("Who can you accommodate? Single Adult")
      expect(page).to have_content("Living space Room(s) in a property with access to shared facilities ")
      expect(page).to have_content("Step free access Some")
      expect(page).to have_content("Properties 3")
      expect(page).to have_content("Single rooms 2")
      expect(page).to have_content("Double rooms 1")
      expect(page).to have_content("Postcode(s) SG13, SG12")
      expect(page).to have_content("Organisation Name My Organisation Name")
      expect(page).to have_content("Organisation Type Charity")
      expect(page).to have_content("Name John Smith")
      expect(page).to have_content("Email john.smith@example.com")
      expect(page).to have_content("Phone number 0123456789")
      expect(page).to have_content("Future contact Agreed")
      expect(page).to have_content("Privacy statement Agreed")

      click_button("Accept And Send")

      expect(page).to have_content("Application complete")

      application = OrganisationExpressionOfInterest.order("created_at DESC").last
      expect(application.as_json).to include({
        type: "organisation",
        family_type: "single_adult",
        living_space: "rooms_in_property",
        step_free: "some",
        property_count: "3",
        single_room_count: "2",
        double_room_count: "1",
        postcode: "SG13, SG12",
        organisation_name: "My Organisation Name",
        organisation_type: "charity",
        agree_future_contact: "true",
        email: "john.smith@example.com",
        fullname: "John Smith",
        phone_number: "0123456789",
        agree_privacy_statement: "true",
      })

      expect(application.ip_address).to eq("127.0.0.1")
      expect(application.user_agent).to eq("DummyBrowser")
      expect(application.started_at).to match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.\d*Z/)
    end
  end
end
