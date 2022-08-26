require "rails_helper"
require "securerandom"

RSpec.describe "Unaccompanied minor - minors details", type: :system do
  let(:task_list_path) { "/sponsor-a-child/task-list" }
  let(:task_list_content) { "Apply for permission to sponsor a child fleeing Ukraine without a parent" }

  before do
    driven_by(:rack_test_user_agent)
    new_application = UnaccompaniedMinor.new
    new_application.save!

    page.set_rack_session(app_reference: new_application.reference)
  end

  describe "entering personal details" do
    it "shows completed on the task list with valid inputs" do
      navigate_to_child_personal_details_name_entry
      enter_name_and_continue
      enter_email_and_continue
      enter_date_of_birth_and_continue

      expect(page).to have_content(task_list_content)
      expect(page).to have_content("completed").once
    end
  end

  describe "entering invalid input" do
    it "prompts the user to select a contact type" do
      navigate_to_child_personal_details_name_entry
      enter_name_and_continue

      click_button("Continue")

      expect(page).to have_content("Error: Please choose one or more of the options")
    end

    it "prompts the user to enter a valid email address" do
      navigate_to_child_personal_details_name_entry
      enter_name_and_continue

      check("Email")
      fill_in("Email", with: "not an email address")
      click_button("Continue")

      expect(page).to have_content("Error: You must enter a valid email address")
    end

    it "prompts the user to enter a valid phone number" do
      navigate_to_child_personal_details_name_entry
      enter_name_and_continue

      check("Phone")
      fill_in("Phone", with: "ABCDEFG")
      click_button("Continue")

      expect(page).to have_content("Error: You must enter a valid phone number")
    end

    it "prompts the user to enter a valid phone number AND valid email" do
      navigate_to_child_personal_details_name_entry
      enter_name_and_continue

      check("Phone")
      fill_in("Phone", with: "ABCDEFG")

      check("Email")
      fill_in("Email", with: "not an email address")

      click_button("Continue")

      expect(page).to have_content("Error: You must enter a valid phone number")
      expect(page).to have_content("Error: You must enter a valid email address")
    end

    it "prompts the user to enter a valid date of birth when no entry is made" do
      navigate_to_child_personal_details_name_entry
      enter_name_and_continue
      enter_email_and_continue

      click_button("Continue")

      expect(page).to have_content("Error: Enter a valid date of birth")
    end
  end

  def navigate_to_task_list
    visit task_list_path
    expect(page).to have_content(task_list_content)
  end

  def navigate_to_child_personal_details_name_entry
    navigate_to_task_list

    click_link("Child's personal details")

    expect(page).to have_content("Enter the name of the child you want to sponsor")
  end

  def enter_name_and_continue
    given_name = "Child"
    family_name = "Minor"

    fill_in("Given name(s)", with: given_name)
    fill_in("Family name", with: family_name)
    click_button("Continue")

    expect(page).to have_content("How can we contact the child?")
    expect(page).to have_content("#{given_name} #{family_name}")
  end

  def enter_email_and_continue
    check("Email")
    fill_in("Email", with: "unaccompanied.minor@test.com")
    click_button("Continue")

    expect(page).to have_content("Enter their date of birth")
  end

  def enter_date_of_birth_and_continue
    minor_dob_under_18_year = Time.zone.now.year - 4

    fill_in("Day", with: 1)
    fill_in("Month", with: 1)
    fill_in("Year", with: minor_dob_under_18_year)

    click_button("Continue")
  end
end
