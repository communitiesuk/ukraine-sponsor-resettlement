require "rails_helper"

RSpec.describe "Local Authority matching form", type: :system do
  before do
    driven_by(:rack_test_user_agent)
  end

  describe "visiting the match form without a valid reference in url" do
    it "redirects user to error page when missing" do
      visit "/match"

      expect(page).to have_content("Reference not found")
    end

    it "redirects user to error page when incorrect format" do
      visit "/match/incorrect-format-reference"

      expect(page).to have_content("Reference not found")
    end
  end

  describe "visiting the match form with a valid reference in url" do
    it "displays the landing page" do
      visit "/match/ANON-XXXX-XXXX-X"

      expect(page).to have_content("I've recorded my interest, what happens now?")
    end
  end
end
