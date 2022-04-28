require "rails_helper"

RSpec.describe "Local Authority matching form", type: :system do
  before do
    driven_by(:rack_test_user_agent)
  end

  describe "visiting the additional_info form without a valid reference in url" do
    it "redirects user to error page when missing" do
      visit "/additional-info/"

      expect(page).to have_content("Reference not found")
    end

    it "redirects user to error page when missing from URL" do
      visit "/additional-info/ref/"

      expect(page).to have_content("Reference not found")
    end

    it "redirects user to error page when incorrect format" do
      visit "/additional-info/ref/incorrect-format-reference"

      expect(page).to have_content("Reference not found")
    end
  end

  describe "visiting the additional_info form with a valid reference in url" do
    it "displays the landing page" do
      visit "/additional-info/ref/ANON-XXXX-XXXX-X"

      expect(page).to have_content("Update your registration of interest")
    end

    it "displays the landing page with mixed case" do
      visit "/additional-info/ref/anon-XX99-X2X1-0"

      expect(page).to have_content("Update your registration of interest")
    end
  end

  describe "completing the additional information form for one property" do
    it "saves all of the answers in the database with routing" do
      visit "/additional-info/ref/ANON-0C84-4DD5-1"

      expect(page).to have_content("Update your registration of interest")
      click_link("Start")

      fill_in("Confirm your full name", with: "John Smith")
      click_button("Continue")

      fill_in("Confirm your email address", with: "john.smith@example.com")
      click_button("Continue")

      fill_in("Confirm your contact telephone number", with: "12345 678 901")
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
      choose("No")
      click_button("Continue")

      expect(page).to have_content("Would you consider allowing guests to bring their pets?")
      choose("No")
      click_button("Continue")

      expect(page).to have_content("Would you like to take part in research to help us improve the Homes for Ukraine service?")
      choose("Yes")
      click_button("Continue")

      expect(page).to have_content("Residential address House number and Street name")
      expect(page).to have_content("Email john.smith@example.com")
      expect(page).to have_content("Name John Smith")
      expect(page).to have_content("Telephone number 12345 678 901")
      expect(page).to have_content("Different address yes")
      expect(page).to have_content("Property one address Property 1 House number and Street name")
      expect(page).to have_content("More properties no")
      expect(page).to have_content("Allow pets no")
      expect(page).to have_content("User research yes")

      click_button("Accept And Send")

      expect(page).to have_content("Registration update complete")
      expect(page).to have_content("ANON-0C84-4DD5-1")
      expect(page).to have_content("Thank you for providing more information for the Homes for Ukraine Scheme")

      application = AdditionalInfo.order("created_at DESC").last
      expect(application.as_json).to include({
        reference: "ANON-0C84-4DD5-1",
        residential_line_1: "House number and Street name",
        residential_town: "Some Town or City",
        residential_postcode: "XX1 1XX",
        fullname: "John Smith",
        email: "john.smith@example.com",
        phone_number: "12345 678 901",
        different_address: "yes",
        property_one_line_1: "Property 1 House number and Street name",
        property_one_town: "Property 1 Some Town or City",
        property_one_postcode: "AA1 1AA",
        more_properties: "no",
        allow_pet: "no",
        user_research: "yes",
      })

      expect(application.ip_address).to eq("127.0.0.1")
    end
  end

  describe "completing the additional information form for more than one property" do
    it "saves all of the answers in the database with routing" do
      visit "/additional-info/ref/ANON-0C84-4DD5-1"

      expect(page).to have_content("Update your registration of interest")
      click_link("Start")

      fill_in("Confirm your full name", with: "John Smith")
      click_button("Continue")

      fill_in("Confirm your email address", with: "john.smith@example.com")
      click_button("Continue")

      fill_in("Confirm your contact telephone number", with: "12345 678 901")
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

      expect(page).to have_content("Would you consider allowing guests to bring their pets?")
      choose("Yes")
      click_button("Continue")

      expect(page).to have_content("Would you like to take part in research to help us improve the Homes for Ukraine service?")
      choose("Yes")
      click_button("Continue")

      expect(page).to have_content("Residential address House number and Street name")
      expect(page).to have_content("Email john.smith@example.com")
      expect(page).to have_content("Name John Smith")
      expect(page).to have_content("Telephone number 12345 678 901")
      expect(page).to have_content("Different address yes")
      expect(page).to have_content("Property one address Property 1 House number and Street name")
      expect(page).to have_content("More properties yes")
      expect(page).to have_content("Allow pets yes")
      expect(page).to have_content("User research yes")

      click_button("Accept And Send")

      expect(page).to have_content("Registration update complete")
      expect(page).to have_content("ANON-0C84-4DD5-1")
      expect(page).to have_content("Thank you for providing more information for the Homes for Ukraine Scheme")

      application = AdditionalInfo.order("created_at DESC").last
      expect(application.as_json).to include({
        reference: "ANON-0C84-4DD5-1",
        residential_line_1: "House number and Street name",
        residential_town: "Some Town or City",
        residential_postcode: "XX1 1XX",
        fullname: "John Smith",
        email: "john.smith@example.com",
        phone_number: "12345 678 901",
        different_address: "yes",
        property_one_line_1: "Property 1 House number and Street name",
        property_one_town: "Property 1 Some Town or City",
        property_one_postcode: "AA1 1AA",
        more_properties: "yes",
        allow_pet: "yes",
        user_research: "yes",
      })

      expect(application.ip_address).to eq("127.0.0.1")
    end
  end

  describe "completing the additional information form" do
    it "saves all of the answers in the database" do
      visit "/additional-info/ref/anon-0C84-4DD5-9"

      expect(page).to have_content("Update your registration of interest")
      click_link("Start")

      fill_in("Confirm your full name", with: "John Smith")
      click_button("Continue")

      fill_in("Confirm your email address", with: "john.smith@example.com")
      click_button("Continue")

      fill_in("Confirm your contact telephone number", with: "12345 678 901")
      click_button("Continue")

      fill_in("Address line 1", with: "House number and Street name")
      fill_in("Town", with: "Some Town or City")
      fill_in("Postcode", with: "XX1 1XX")
      click_button("Continue")

      expect(page).to have_content("Is the property you’re offering at a different address to your home?")
      choose("No")
      click_button("Continue")

      expect(page).to have_content("Would you consider allowing guests to bring their pets?")
      choose("No")
      click_button("Continue")

      expect(page).to have_content("Would you like to take part in research to help us improve the Homes for Ukraine service?")
      choose("No")
      click_button("Continue")

      expect(page).to have_content("Residential address House number and Street name")
      expect(page).to have_content("Email john.smith@example.com")
      expect(page).to have_content("Name John Smith")
      expect(page).to have_content("Telephone number 12345 678 901")
      expect(page).to have_content("Different address no")
      expect(page).to have_content("Allow pets no")
      expect(page).to have_content("User research no")

      click_button("Accept And Send")

      expect(page).to have_content("Registration update complete")
      expect(page).to have_content("ANON-0C84-4DD5-9")
      expect(page).to have_content("Thank you for providing more information for the Homes for Ukraine Scheme")

      application = AdditionalInfo.order("created_at DESC").last
      expect(application.as_json).to include({
        reference: "ANON-0C84-4DD5-9",
        residential_line_1: "House number and Street name",
        residential_town: "Some Town or City",
        residential_postcode: "XX1 1XX",
        fullname: "John Smith",
        email: "john.smith@example.com",
        phone_number: "12345 678 901",
        different_address: "no",
        allow_pet: "no",
        user_research: "no",
      })

      expect(application.ip_address).to eq("127.0.0.1")
    end
  end
end
