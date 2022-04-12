require "rails_helper"

RSpec.describe "Local Authority matching form", type: :system do
  before do
    driven_by(:rack_test_user_agent)
  end

  describe "visiting the match form without reference in url" do
    it "redirects user to error page" do
      visit "/match"

      expect(page).to have_content("Reference not found")
    end
  end
end
