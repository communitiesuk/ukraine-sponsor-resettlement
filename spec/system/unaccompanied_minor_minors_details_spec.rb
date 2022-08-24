require "rails_helper"
require "securerandom"

RSpec.describe "Unaccompanied minor minors details", type: :system do
  before do
    driven_by(:rack_test_user_agent)
  end

  describe "submitting the form for child's flow" do
    it "saves all the minors data" do
      new_application = UnaccompaniedMinor.new
      new_application.save!
      minor_dob_under_18_year = Time.zone.now.year - 4

      page.set_rack_session(app_reference: new_application.reference)

      visit "/sponsor-a-child/task-list"
      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")

      click_link("Child's personal details")
      expect(page).to have_content("Enter the name of the child you want to sponsor")

      fill_in("Given name(s)", with: "Jane")
      fill_in("Family name", with: "Doe")

      click_button("Continue")
      expect(page).to have_content("How can we contact")

      check("Email")
      fill_in("Email", with: "unaccompanied.minor@test.com")

      click_button("Continue")
      expect(page).to have_content("Jane Doe")
      expect(page).to have_content("Enter their date of birth")

      fill_in("Day", with: 3)
      fill_in("Month", with: 6)
      fill_in("Year", with: minor_dob_under_18_year)

      click_button("Continue")
      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")
    end
  end

  describe "Goes through child flow and enters DoB" do
    it "enters blank DoB" do
      new_application = UnaccompaniedMinor.new
      new_application.save!

      page.set_rack_session(app_reference: new_application.reference)

      visit "/sponsor-a-child/task-list"
      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")

      click_link("Child's personal details")
      expect(page).to have_content("Enter the name of the child you want to sponsor")

      fill_in("Given name(s)", with: "Jane")
      fill_in("Family name", with: "Doe")

      click_button("Continue")
      expect(page).to have_content("How can we contact")

      check("Email")
      fill_in("Email", with: "unaccompanied.minor@test.com")

      click_button("Continue")
      expect(page).to have_content("date of birth")

      click_button("Continue")
      expect(page).to have_content("Enter a valid date of birth")
    end
  end
end
