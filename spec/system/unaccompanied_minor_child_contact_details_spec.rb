RSpec.describe "Unaccompanied minor - minors details", type: :system do
  let(:task_list_path) { "/sponsor-a-child/task-list" }
  let(:task_list_content) { "Apply for approval to provide a safe home for a child from Ukraine" }
  let(:minors_email) { "unaccompanied.minor@test.com" }
  let(:minors_phone) { "07983111111" }
  let(:minors_dob) { Time.zone.now - 4.years }

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
      uam_enter_minors_contact_details(email: minors_email, confirm_email: minors_email)
      enter_date_of_birth_and_continue

      expect(page).to have_content(task_list_content)
      expect(page).to have_content("completed").once
    end

    it "clears email and phone number when none is chosen" do
      navigate_to_child_personal_details_name_entry
      enter_name_and_continue

      uam_enter_minors_contact_details(email: minors_email, confirm_email: minors_email, telephone: minors_phone, confirm_telephone: minors_phone, select_none: true)

      expect(page).to have_content("Enter their date of birth")

      enter_date_of_birth_and_continue

      expect(page).to have_content(task_list_content)

      visit "sponsor-a-child/steps/33"

      expect(page).to have_checked_field("They cannot be contacted")
      expect(page).to have_unchecked_field("Phone")
      expect(page).to have_unchecked_field("Email")

      email = find_field("unaccompanied-minor-minor-email-field").value
      expect(email).to eq("")

      phone_number = find_field("unaccompanied-minor-minor-phone-number-field").value
      expect(phone_number).to eq("")
    end

    it "retains DoB when page is reloaded" do
      navigate_to_child_personal_details_name_entry
      enter_name_and_continue
      uam_enter_minors_contact_details(email: minors_email, confirm_email: minors_email)
      enter_date_of_birth_and_continue

      visit "sponsor-a-child/steps/34"

      expect(page).to have_field("Day", with: minors_dob.day)
      expect(page).to have_field("Month", with: minors_dob.month)
      expect(page).to have_field("Year", with: minors_dob.year)
    end
  end

  describe "entering invalid input" do
    it "prompts the user to select a contact type" do
      navigate_to_child_personal_details_name_entry
      enter_name_and_continue

      click_button("Continue")

      expect(page).to have_content("Error: Please choose one or more of the options")
    end

    it "prompts the user to enter confirmation email address" do
      navigate_to_child_personal_details_name_entry
      enter_name_and_continue

      uam_enter_minors_contact_details(email: minors_email, confirm_email: "notmatchingemail@test.com")

      expect(page).to have_checked_field("Email")
      expect(page).to have_content("Error: Emails must match")
    end

    it "prompts the user to enter a valid email address" do
      navigate_to_child_personal_details_name_entry
      enter_name_and_continue

      uam_enter_minors_contact_details(email: "not an email address", confirm_email: "not an email address")

      expect(page).to have_checked_field("Email")
      expect(page).to have_content("Error: You must enter a valid email address")
    end

    it "prompts for valid email address ignores confirmation entry" do
      navigate_to_child_personal_details_name_entry
      enter_name_and_continue

      uam_enter_minors_contact_details(email: "not an email address", confirm_email: "valid@example.com")

      expect(page).to have_checked_field("Email")
      expect(page).to have_content("Error: You must enter a valid email address")
    end

    it "prompts the user to enter a valid phone number" do
      navigate_to_child_personal_details_name_entry
      enter_name_and_continue

      uam_enter_minors_contact_details(telephone: "ABCDEFG")

      expect(page).to have_content("Error: Enter a telephone number in the correct format")
    end

    it "prompts the user to matching phone numbers" do
      navigate_to_child_personal_details_name_entry
      enter_name_and_continue

      uam_enter_minors_contact_details(telephone: "07123123123", confirm_telephone: "07234234234")

      expect(page).to have_content("Error: Phone numbers must match")
    end

    it "prompts the user to enter a valid phone number AND valid email" do
      navigate_to_child_personal_details_name_entry
      enter_name_and_continue

      uam_enter_minors_contact_details(email: "not an email address", confirm_email: "not an email address", telephone: "ABCDEFG")

      expect(page).to have_content("Error: Enter a telephone number in the correct format")
      expect(page).to have_content("Error: You must enter a valid email address")
    end

    it "prompts the user to enter a valid date of birth when no entry is made" do
      navigate_to_child_personal_details_name_entry
      enter_name_and_continue
      uam_enter_minors_contact_details(email: minors_email, confirm_email: minors_email)

      expect(page).to have_content("Enter their date of birth")

      click_button("Continue")

      expect(page).to have_content("Error: Enter a valid date of birth")
    end

    it "does not save phone number if box is unchecked" do
      navigate_to_child_personal_details_name_entry
      enter_name_and_continue

      check("Email")
      fill_in("Email", with: minors_email)
      fill_in("unaccompanied_minor[minor_email_confirm]", with: minors_email)
      check("Phone")
      fill_in("Phone number", with: "ABCDEFG")
      uncheck("Phone")
      click_button("Continue")

      expect(page).to have_content("Enter their date of birth")

      visit "/sponsor-a-child/steps/33"

      expect(page).to have_unchecked_field("Phone")
      check("Phone")
      expect(page).to have_field("Phone number", with: "")
    end

    it "removes old number if box is unchecked" do
      navigate_to_child_personal_details_name_entry
      enter_name_and_continue
      uam_enter_minors_contact_details(email: minors_email, confirm_email: minors_email, telephone: minors_phone, confirm_telephone: minors_phone)

      expect(page).to have_content("Enter their date of birth")

      visit "/sponsor-a-child/steps/33"
      uncheck("Phone")
      expect(page).to have_unchecked_field("Phone")
      click_button("Continue")

      expect(page).to have_content("Enter their date of birth")
      visit "/sponsor-a-child/steps/33"

      expect(page).to have_unchecked_field("Phone")
      check("Phone")
      expect(page).to have_field("Phone number", with: "")
    end

    it "does not save email if box is unchecked" do
      navigate_to_child_personal_details_name_entry
      enter_name_and_continue

      check("Email")
      fill_in("Email", with: minors_email)
      fill_in("unaccompanied_minor[minor_email_confirm]", with: minors_email)
      check("Phone")
      fill_in("Phone number", with: minors_phone)
      fill_in("unaccompanied_minor[minor_phone_number_confirm]", with: minors_phone)
      uncheck("Email")
      click_button("Continue")

      expect(page).to have_content("Enter their date of birth")

      visit "/sponsor-a-child/steps/33"

      expect(page).to have_unchecked_field("Email")
      check("Email")
      expect(page).to have_field("Email", with: "")
    end

    it "removes old email if box is unchecked" do
      navigate_to_child_personal_details_name_entry
      enter_name_and_continue
      uam_enter_minors_contact_details(email: minors_email, confirm_email: minors_email, telephone: minors_phone, confirm_telephone: minors_phone)

      expect(page).to have_content("Enter their date of birth")

      visit "/sponsor-a-child/steps/33"
      uncheck("Email")

      expect(page).to have_unchecked_field("Email")
      click_button("Continue")

      expect(page).to have_content("Enter their date of birth")
      visit "/sponsor-a-child/steps/33"

      expect(page).to have_unchecked_field("Email")
      check("Email")
      expect(page).to have_field("Email", with: "")
      expect(page).to have_field("unaccompanied_minor[minor_email_confirm]", with: "")
    end

    it "prompts the user to enter a valid date of birth when future date is entered" do
      tomorrow = Date.current.tomorrow

      navigate_to_child_personal_details_name_entry
      enter_name_and_continue
      uam_enter_minors_contact_details(email: minors_email, confirm_email: minors_email)

      fill_in("Day", with: tomorrow.day)
      fill_in("Month", with: tomorrow.month)
      fill_in("Year", with: tomorrow.year)

      click_button("Continue")

      expect(page).to have_content("Error: This date cannot be in the future. Enter a valid date of birth.")
    end
  end

  describe "checking answers" do
    it "displays the entered telephone and email contact details" do
      navigate_to_child_personal_details_name_entry
      enter_name_and_continue
      uam_enter_minors_contact_details(email: minors_email, confirm_email: minors_email, telephone: minors_phone, confirm_telephone: minors_phone)
      enter_date_of_birth_and_continue

      expect(page).to have_content(task_list_content)

      visit "/sponsor-a-child/check-answers"
      expect(page).to have_content("Check your answers before sending your application")
      expect(page).to have_content(minors_phone)
      expect(page).to have_content(minors_email)
    end

    it "displays none on check answers" do
      navigate_to_child_personal_details_name_entry
      enter_name_and_continue
      uam_enter_minors_contact_details(select_none: true)
      enter_date_of_birth_and_continue

      expect(page).to have_content(task_list_content)

      visit "/sponsor-a-child/check-answers"
      expect(page).to have_content("Check your answers before sending your application")
      expect(page).to have_content("They cannot be contacted")
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

    fill_in_name(given_name, family_name)

    expect(page).to have_content("How can we contact the child?")
    expect(page).to have_content("#{given_name} #{family_name}")
  end

  def enter_date_of_birth_and_continue
    fill_in("Day", with: minors_dob.day)
    fill_in("Month", with: minors_dob.month)
    fill_in("Year", with: minors_dob.year)

    click_button("Continue")
  end
end
