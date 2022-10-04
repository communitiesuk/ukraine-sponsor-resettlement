module UnaccompaniedMinorHelpers
  START_PAGE_CONTENT = "You are eligible to use this service".freeze
  TASK_LIST_CONTENT = "Apply for approval to provide a safe home for a child from Ukraine".freeze
  SPONSOR_OTHER_NAME_CONTENT = "Have you ever been known by another name?".freeze

  def uam_enter_valid_complete_eligibility_section
    visit "/sponsor-a-child/start"
    expect(page).to have_content("Apply to provide a safe home for a child from Ukraine")

    click_link("Start now")

    expect(page).to have_content("Check if you are eligible to use this service")

    click_link("Continue")

    expect(page).to have_content("Is the child you want to sponsor under 18?")
    uam_choose_option("Yes")

    expect(page).to have_content("Was the child living in Ukraine on or before 31 December 2021?")
    uam_choose_option("Yes")

    expect(page).to have_content("Are they travelling to the UK with a parent or legal guardian?")
    uam_choose_option("No")

    expect(page).to have_content("Can you upload both consent forms?")
    uam_choose_option("Yes")

    expect(page).to have_content("Can you commit to hosting the child for the minimum period?")
    uam_choose_option("Yes")

    expect(page).to have_content("Do you have permission to live in the UK for the minimum period?")
    uam_choose_option("Yes")

    expect(page).to have_content(START_PAGE_CONTENT)
  end

  def uam_click_task_list_link(link_text)
    expect(page).to have_content(TASK_LIST_CONTENT)
    click_link(link_text)
  end

  def uam_start_page_to_task_list
    expect(page).to have_content(START_PAGE_CONTENT)
    click_link("Start application")
    expect(page).to have_content(TASK_LIST_CONTENT)
  end

  def uam_enter_sponsor_name(given: "Spencer", family: "Sponsor", click_continue: true)
    expect(page).to have_content("Enter your name")

    fill_in_name(given, family, click_continue:)

    if click_continue
      expect(page).to have_content(SPONSOR_OTHER_NAME_CONTENT)
    end
  end

  def uam_enter_sponsor_not_known_by_another_name(click_continue: true)
    expect(page).to have_content(SPONSOR_OTHER_NAME_CONTENT)

    uam_choose_option("No", click_continue:)

    if click_continue
      expect(page).to have_content(TASK_LIST_CONTENT)
    end
  end

  def uam_enter_sponsor_other_name
    expect(page).to have_content(SPONSOR_OTHER_NAME_CONTENT)

    uam_choose_option("Yes")
    fill_in_name("Another", "Sponsor", click_continue: true)
    click_link("Continue")

    expect(page).to have_content(TASK_LIST_CONTENT)
  end

  def uam_enter_sponsor_contact_details
    expect(page).to have_content("Enter your email address")

    fill_in("Email", with: "spencer.sponsor@example.com")
    fill_in("unaccompanied_minor[email_confirm]", with: "spencer.sponsor@example.com")
    click_button("Continue")

    expect(page).to have_content("Enter your UK phone number")

    fill_in("UK phone number", with: "07123123123")
    fill_in("Confirm phone number", with: "07123123123")
    click_button("Continue")

    expect(page).to have_content(TASK_LIST_CONTENT)
  end

  def uam_enter_sponsor_additional_details
    expect(page).to have_content("Do you have any of these identity documents?")

    choose("Passport")
    fill_in("Passport number", with: "123123123")
    click_button("Continue")

    expect(page).to have_content("Enter your date of birth")

    uam_fill_in_date_of_birth(Time.zone.now - 21.years)

    expect(page).to have_content("Enter your nationality")

    select("Denmark", from: "unaccompanied-minor-nationality-field")
    click_button("Continue")

    expect(page).to have_content("Have you ever held any other nationalities?")
    uam_choose_option("No")

    expect(page).to have_content(TASK_LIST_CONTENT)
  end

  def uam_enter_residential_address
    expect(page).to have_content("Enter the address where the child will be living in the UK")
    fill_in("Address line 1", with: "Address line 1")
    fill_in("Town", with: "Address town")
    fill_in("Postcode", with: "XX1 1XX")
    click_button("Continue")

    expect(page).to have_content("Will you be living at this address?")
    uam_choose_option("Yes")

    expect(page).to have_content("Will anyone else over the age of 16 be living at this address?")
    uam_choose_option("No")

    expect(page).to have_content(TASK_LIST_CONTENT)
  end

  def uam_enter_childs_personal_details
    expect(page).to have_content("Enter the name of the child you want to sponsor")
    fill_in_name("Milly", "Minor")

    expect(page).to have_content("How can we contact the child?")
    uam_enter_minors_contact_details(select_none: true)

    expect(page).to have_content("Enter their date of birth")
    uam_fill_in_date_of_birth(Time.zone.now - 4.years)

    expect(page).to have_content(TASK_LIST_CONTENT)
  end

  def uam_upload_consent_forms
    expect(page).to have_content("You must upload 2 completed parental consent forms")
    click_button("Continue")

    expect(page).to have_content("Upload the UK sponsorship arrangement consent form")
    test_file_path = File.join(File.dirname(__FILE__), "..", "uk-test-document.pdf")
    attach_file("unaccompanied-minor-uk-parental-consent-field", test_file_path)
    click_button("Continue")

    click_link("Upload Ukrainian consent form")
    expect(page).to have_content("Upload the Ukraine certified consent form")
    test_file_path = File.join(File.dirname(__FILE__), "..", "ukraine-test-document.pdf")
    attach_file("unaccompanied-minor-ukraine-parental-consent-field", test_file_path)
    click_button("Continue")

    expect(page).to have_content(TASK_LIST_CONTENT)
  end

  def uam_confirm_privacy_statement
    expect(page).to have_content("Confirm you have read the privacy statement and all people involved agree that the information you have provided can be used for the Homes for Ukraine scheme")

    check("unaccompanied_minor[privacy_statement_confirm]")
    click_button("Continue")

    expect(page).to have_content(TASK_LIST_CONTENT)
  end

  def uam_confirm_eligibilty
    expect(page).to have_content("Confirm your eligibility to sponsor a child from Ukraine")

    check("unaccompanied_minor[sponsor_declaration]")
    click_button("Continue")

    expect(page).to have_content(TASK_LIST_CONTENT)
  end

  def uam_check_answers_and_submit
    expect(page).to have_content("Check your answers before sending your application")

    find("button[type=submit]").click

    expect(page).to have_content("SPON-")
  end

  def fill_in_name(given, family, click_continue: true)
    fill_in("Given names", with: given)
    fill_in("Family name", with: family)

    if click_continue
      click_button("Continue")
    end
  end

  def uam_fill_in_date_of_birth(date, click_continue: true)
    fill_in("Day", with: date.day)
    fill_in("Month", with: date.month)
    fill_in("Year", with: date.year)

    if click_continue
      click_button("Continue")
    end
  end

  def uam_choose_option(choice, click_continue: true)
    choose(choice)

    if click_continue
      click_button("Continue")
    end
  end

  def uam_enter_minors_contact_details(email: nil, confirm_email: nil, telephone: nil, confirm_telephone: nil, select_none: false, click_continue: true)
    expect(page).to have_content("How can we contact the child?")

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

    if click_continue
      click_button("Continue")
    end
  end
end
