require "rails_helper"
require "securerandom"

RSpec.describe "Unaccompanied minor minors details", type: :system do
  before do
    driven_by(:rack_test_user_agent)
  end

  describe "completing the minors details with valid input" do
    it "saves all the minors data and shows completed status" do
      new_application = UnaccompaniedMinor.new
      new_application.save!
      page.set_rack_session(app_reference: new_application.reference)

      minor_dob_under_18_year = Time.zone.now.year - 4
      task_list_content = "Apply for permission to sponsor a child fleeing Ukraine without a parent".freeze

      visit "/sponsor-a-child/task-list"
      expect(page).to have_content(task_list_content)

      click_link("Child's personal details")
      expect(page).to have_content("Enter the name of the child you want to sponsor")

      fill_in("Given name(s)", with: "Child")
      fill_in("Family name", with: "Minor")

      click_button("Continue")
      expect(page).to have_content("How can we contact the child?")

      check("Email")
      fill_in("Email", with: "minor@example.com")

      click_button("Continue")
      expect(page).to have_content("Child Minor")
      expect(page).to have_content("Enter their date of birth")

      fill_in("Day", with: 1)
      fill_in("Month", with: 1)
      fill_in("Year", with: minor_dob_under_18_year)

      click_button("Continue")
      expect(page).to have_content(task_list_content)
      expect(page).to have_content("completed").once
    end
  end

  describe "prompting the user for valid input" do
    it "prompts the user to select a contact type" do
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
      expect(page).to have_content("How can we contact the child?")

      click_button("Continue")
      expect(page).to have_content("Please choose one or more of the options")
    end

    it "prompts the user to enter a valid email address" do
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
      expect(page).to have_content("How can we contact the child?")

      check("Email")
      fill_in("Email", with: "not an email address")

      click_button("Continue")
      expect(page).to have_content("You must enter a valid email address")
    end

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
