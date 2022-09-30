RSpec.describe "Unaccompanied minor full journey", type: :system do
  let(:task_list_path) { "/sponsor-a-child/task-list" }
  let(:task_list_content) { "Apply for approval to provide a safe home for a child from Ukraine" }
  let(:minors_email) { "unaccompanied.minor@test.com" }
  let(:minors_phone) { "07983111111" }
  let(:minors_dob) { Time.zone.now - 4.years }

  before do
    driven_by(:rack_test_user_agent)
    # new_application = UnaccompaniedMinor.new
    # new_application.save!
    #
    # page.set_rack_session(app_reference: new_application.reference)
  end

  describe "entering minimum valid details" do
    it "creates valid JSON to transfer to foundry" do
      uam_complete_eligibity_section
      uam_start_page_to_task_list
      uam_enter_sponsor_name
      uam_sponsor_known_by_another_name

      ## SEE confirm_page_spec for duplication!
      #### Contact details
      click_link("Contact details")

      expect(page).to have_content("Enter your email address")
      fill_in("Email", with: "sponsor@example.com")
      fill_in("unaccompanied_minor[email_confirm]", with: "sponsor@example.com")
      click_button("Continue")

      expect(page).to have_content("Enter your UK phone number")
      fill_in("UK phone number", with: "07123123123")
      fill_in("Confirm phone number", with: "07123123123")
      click_button("Continue")
      expect(page).to have_content(task_list_content)
      # check_sections_complete(0)
      ###########################

      ### Additional details
      click_link("Additional details")

      expect(page).to have_content("Do you have any of these identity documents?")
      choose("Passport")
      fill_in("Passport number", with: "123123123")
      click_button("Continue")

      expect(page).to have_content("Enter your date of birth")
      uam_fill_in_date_of_birth(Time.zone.now - 18.years)

      expect(page).to have_content("Enter your nationality")
      select("Denmark", from: "unaccompanied-minor-nationality-field")
      click_button("Continue")

      expect(page).to have_content("Have you ever held any other nationalities?")
      uam_choose_option("No")

      expect(page).to have_content(task_list_content)
      # check_sections_complete(1)

      ###################

      click_link("Address")

      expect(page).to have_content("Enter the address where the child will be living in the UK")
      fill_in("Address line 1", with: "Address line 1")
      fill_in("Town", with: "Address town")
      fill_in("Postcode", with: "XX1 1XX")
      click_button("Continue")

      expect(page).to have_content("Will you be living at this address?")
      uam_choose_option("Yes")

      expect(page).to have_content("Will anyone else over the age of 16 be living at this address?")
      uam_choose_option("No")

      # expect(page).to have_content(task_list_content)
      # check_sections_complete(2)
      #####################################

      # navigate_to_child_personal_details_name_entry
      # enter_name_and_continue
      # enter_contact_details_and_continue(email: minors_email, confirm_email: minors_email)
      # enter_date_of_birth_and_continue
      # expect(page).to have_content("completed").once

      # app_ref = page.get_rack_session_key("app_reference")
      # application = UnaccompaniedMinor.find_by_reference(app_ref)
      # puts JSON.pretty_generate(application.as_json)
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

  def enter_contact_details_and_continue(email: nil, confirm_email: nil, telephone: nil, confirm_telephone: nil, select_none: false)
    if email.present? || confirm_email.present?
      check("Email")
    end

    if email.present?
      fill_in("Email", with: email)
    end

    if confirm_email.present?
      fill_in("unaccompanied_minor[minor_email_confirm]", with: confirm_email)
    end

    if telephone.present?
      check("Phone")
      fill_in("Phone number", with: telephone)
    end

    if confirm_telephone.present?
      fill_in("unaccompanied_minor[minor_phone_number_confirm]", with: confirm_telephone)
    end

    if select_none
      check("They cannot be contacted")
    end

    click_button("Continue")
  end

  def enter_date_of_birth_and_continue
    fill_in("Day", with: minors_dob.day)
    fill_in("Month", with: minors_dob.month)
    fill_in("Year", with: minors_dob.year)

    click_button("Continue")
  end
end
