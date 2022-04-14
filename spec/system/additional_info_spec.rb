require "rails_helper"

RSpec.describe "Local Authority matching form", type: :system do
  before do
    driven_by(:rack_test_user_agent)
  end

  describe "visiting the additional_info form without a valid reference in url" do
    it "redirects user to error page when missing" do
      visit "/additional-info"

      expect(page).to have_content("Reference not found")
    end

    it "redirects user to error page when incorrect format" do
      visit "/additional-info/incorrect-format-reference"

      expect(page).to have_content("Reference not found")
    end
  end

  describe "visiting the additional_info form with a valid reference in url" do
    it "displays the landing page" do
      visit "/additional-info/ANON-XXXX-XXXX-X"

      expect(page).to have_content("I've recorded my interest, what happens now?")
    end

    it "displays the landing page with mixed case" do
      visit "/additional-info/anon-XX99-X2X1-0"

      expect(page).to have_content("I've recorded my interest, what happens now?")
    end
  end
end
