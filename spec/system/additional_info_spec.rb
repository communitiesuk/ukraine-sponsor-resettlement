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

      expect(page).to have_content("I've recorded my interest, what happens now?")
    end

    it "displays the landing page with mixed case" do
      visit "/additional-info/ref/anon-XX99-X2X1-0"

      expect(page).to have_content("I've recorded my interest, what happens now?")
    end
  end

  describe "completing the additional information form" do
    it "saves all of the answers in the database" do
      visit "/additional-info/ref/anon-0C84-4DD5-9"

      expect(page).to have_content("I've recorded my interest, what happens now?")
      click_link("Provide additional information")

      fill_in("Enter your full name", with: "John Smith")
      click_button("Continue")

      fill_in("Enter your email address", with: "john.smith@example.com")
      click_button("Continue")

      fill_in("Enter your contact telephone number", with: "1234567890")
      click_button("Continue")

      expect(page).to have_content("Name John Smith")
      expect(page).to have_content("Email john.smith@example.com")
      expect(page).to have_content("Telephone number 1234567890")

      click_button("Accept And Send")

      expect(page).to have_content("Application complete")
      expect(page).to have_content("ANON-0C84-4DD5-9")
      expect(page).to have_content("Thank you for providing additional information for the Homes for Ukraine Scheme")

      application = AdditionalInfo.order("created_at DESC").last
      expect(application.as_json).to include({
                                                 reference: "ANON-0C84-4DD5-9",
                                                 email: "john.smith@example.com",
                                                 fullname: "John Smith",
                                              })

      expect(application.ip_address).to eq("127.0.0.1")
    end
  end
end
