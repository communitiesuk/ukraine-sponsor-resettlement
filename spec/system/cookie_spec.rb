require "rails_helper"

RSpec.describe "GDS Cookie Banner Form", type: :system do
  before do
    driven_by(:rack_test_user_agent)
  end

  describe "testing the cookie banner form " do
    it "cookies banner shows up on the page on first visit to the site" do
      visit "/"
      expect(page).to have_content("Cookies on Homes for Ukraine")
    end

    it "takes you to the accepted cookies screen on pressing accept " do
      visit "/"
      click_link("Accept analytics cookies")
      expect(page).to have_content("You’ve accepted additional cookies. ")
    end

    it "takes you to the rejected cookies screen on pressing reject " do
      visit "/"
      click_link("Reject analytics cookies")
      expect(page).to have_content("You’ve rejected additional cookies. ")
    end

    it "remove the cookie banner upon clicking the Hide cookie message button " do
      visit "/"
      click_link("Accept analytics cookies")
      click_link("Hide cookie message")

      expect(page).not_to have_content("You’ve accepted additional cookies. ")
    end

    it "does not display the cookie banner having gone throught the e2e process once pressing accept " do
      visit "/"
      click_link("Accept analytics cookies")
      click_link("Hide cookie message")
      visit "/sponsor-a-child/start"

      expect(page).not_to have_content("Cookies on Homes for Ukraine")
    end

    it "does not display the cookie banner having gone throught the e2e process once pressing reject " do
      visit "/"
      click_link("Reject analytics cookies")
      click_link("Hide cookie message")
      visit "/sponsor-a-child/start"
      expect(page).not_to have_content("Cookies on Homes for Ukraine")
    end

    it "displays the cookie banner if start on another page" do
      visit "/sponsor-a-child/start"
      expect(page).to have_content("Cookies on Homes for Ukraine")
    end
  end
end
