require "tempfile"

module UnaccompaniedMinorHelpers
  START_PAGE_CONTENT = "You are eligible to use this service".freeze
  TASK_LIST_CONTENT = "Apply for approval to provide a safe home for a child from Ukraine".freeze
  SPONSOR_OTHER_NAME_CONTENT = "Have you ever been known by another name?".freeze

  def uam_enter_valid_complete_eligibility_section
    visit "/sponsor-a-child/start"
    expect(page).to have_content("Apply to provide a safe home for a child from Ukraine")

    click_on("Start now")

    expect(page).to have_content("Check if you are eligible to use this service")

    click_on("Continue")

    expect(page).to have_content("Is the person you want to sponsor under 18?")
    uam_choose_option("Yes")

    expect(page).to have_content("Was the child living in Ukraine before 1 January 2022?")
    uam_choose_option("Yes")

    expect(page).to have_content("Are they applying for a visa under the Homes for Ukraine Scheme with their parent or legal guardian, or to join them in the UK?")
    uam_choose_option("No")

    expect(page).to have_content("Can you upload both consent forms?")
    uam_choose_option("Yes")

    expect(page).to have_content("Can you commit to hosting the child for the minimum period?")
    uam_choose_option("Yes")

    expect(page).to have_content("Do you have permission to live permanently in the UK?")
    uam_choose_option("Yes")

    expect(page).to have_content(START_PAGE_CONTENT)
  end

  def uam_click_task_list_link(link_text)
    expect(page).to have_content(TASK_LIST_CONTENT)
    click_on(link_text)
  end

  def uam_start_page_to_task_list
    expect(page).to have_content(START_PAGE_CONTENT)
    click_on("Start application")
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

    expect(page).to have_content("You have added")
    click_on("Continue")

    expect(page).to have_content(TASK_LIST_CONTENT)
  end

  def uam_enter_sponsor_contact_details
    expect(page).to have_content("Enter your email address")

    fill_in("Email", with: "spencer.sponsor@example.com")
    fill_in("unaccompanied_minor[email_confirm]", with: "spencer.sponsor@example.com")
    click_on("Continue")

    expect(page).to have_content("Enter your UK mobile number")

    fill_in("UK mobile number", with: "07123123123")
    fill_in("Confirm mobile number", with: "07123123123")
    click_on("Continue")

    expect(page).to have_content(TASK_LIST_CONTENT)
  end

  def uam_enter_sponsor_identity_documents(option)
    expect(page).to have_content("Do you have any of these identity documents?")

    choose(option)

    if option == "I don't have any of these"
      click_on("Continue")
      expect(page).to have_content("Can you prove your identity?")
      fill_in("unaccompanied_minor[no_identification_reason]", with: "Minions ate them all")
      click_on("Continue")
    else
      fill_in("#{option} number", with: "123123123")
    end

    click_on("Continue")
  end

  def uam_enter_sponsor_additional_details(
    id_option: "Passport",
    nationality: "Denmark", other_nationalities: []
  )
    uam_enter_sponsor_identity_documents(id_option)

    expect(page).to have_content("Enter your date of birth")
    uam_fill_in_date_of_birth(Time.zone.now - 21.years)

    uam_enter_sponsor_nationalities(nationality:, other_nationalities:)

    expect(page).to have_content(TASK_LIST_CONTENT)
  end

  def uam_enter_sponsor_nationalities(nationality: "Denmark", other_nationalities: nil)
    expect(page).to have_content("Enter your nationality")

    select(nationality, from: "unaccompanied-minor-nationality-field")
    click_on("Continue")

    expect(page).to have_content("Have you ever held any other nationalities?")

    if other_nationalities.blank?
      uam_choose_option("No")
    else
      uam_choose_option("Yes")

      other_nationalities.each_with_index do |element, index|
        expect(page).to have_content("Enter your other nationality")
        select(element)
        click_on("Continue")
        expect(page).to have_content("Other nationalities")

        if (index + 1) < other_nationalities.length
          click_on("Add another nationality")
        else
          click_on("Continue")
        end
      end
    end
  end

  def uam_enter_residential_address(different_address: false)
    expect(page).to have_content("Enter the address where the child will be living in the UK")
    uam_enter_address

    expect(page).to have_content("Will you be living at this address?")

    if different_address
      uam_choose_option("No")

      expect(page).to have_content("Enter the address where you will be living in the UK")
      uam_enter_address(line1: "Other address line 1", line2: "Other address line 2", town: "Other town", postcode: "RM18 1JP")

      expect(page).to have_content("Enter the name of a person over 16 who will live with the child")
      fill_in_name("Other", "Person")

      expect(page).to have_content("You have added")
      click_on("Continue")
      expect(page).to have_content(TASK_LIST_CONTENT)

      uam_click_task_list_link("Other Person details")
      expect(page).to have_content("Enter this person's date of birth")
      uam_fill_in_date_of_birth(Time.zone.now - 17.years)

      expect(page).to have_content("Enter their nationality")
      select("Bermuda")
      click_on("Continue")

      expect(page).to have_content("Do they have any of these identity documents?")
      uam_choose_option("I don't have any of these")
    else
      uam_choose_option("Yes")

      expect(page).to have_content("Will anyone else over the age of 16 be living at this address?")
      uam_choose_option("No")
    end

    expect(page).to have_content(TASK_LIST_CONTENT)
  end

  def uam_enter_address(line1: "Address line 1", line2: nil, town: "Town", postcode: "XX1 1XX")
    fill_in("Address line 1", with: line1)

    if line2.present?
      fill_in("Address line 2", with: line2)
    end

    fill_in("Town", with: town)
    fill_in("Postcode", with: postcode)

    click_on("Continue")
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
    click_on("Continue")

    expect(page).to have_content("Upload the UK sponsorship arrangement consent form")
    test_file_path = File.join(File.dirname(__FILE__), "..", "uk-test-document.pdf")
    attach_file("unaccompanied-minor-uk-parental-consent-field", test_file_path)
    click_on("Continue")

    click_on("Upload Ukrainian consent form")
    expect(page).to have_content("Upload the Ukraine certified consent form")
    test_file_path = File.join(File.dirname(__FILE__), "..", "ukraine-test-document.pdf")
    attach_file("unaccompanied-minor-ukraine-parental-consent-field", test_file_path)
    click_on("Continue")

    expect(page).to have_content(TASK_LIST_CONTENT)
  end

  def uam_confirm_privacy_statement
    expect(page).to have_content("Confirm you have read the privacy statement")

    check("unaccompanied_minor[privacy_statement_confirm]")
    click_on("Continue")

    expect(page).to have_content(TASK_LIST_CONTENT)
  end

  def uam_confirm_eligibilty
    expect(page).to have_content("Confirm your eligibility to sponsor a child from Ukraine")

    check("unaccompanied_minor[sponsor_declaration]")
    click_on("Continue")

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
      click_on("Continue")
    end
  end

  def uam_fill_in_date_of_birth(date, click_continue: true)
    fill_in("Day", with: date.day)
    fill_in("Month", with: date.month)
    fill_in("Year", with: date.year)

    if click_continue
      click_on("Continue")
    end
  end

  def uam_choose_option(choice, click_continue: true)
    choose(choice)

    if click_continue
      click_on("Continue")
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
      uncheck("Email")
      uncheck("Phone")
    end

    if click_continue
      click_on("Continue")
    end
  end

  def make_malicious_file
    file = Tempfile.new(["malicious-test-file", ".pdf"])
    # We need to construct the EICAR test string from multiple parts because if it appears in it's entirely in the
    # source file our dev machine's AV will be unhappy

    # rubocop:disable Style/StringConcatenation
    file.write("X5O!P%@AP[4\\PZX54(P^)7CC)7}$EICAR" + "-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*")
    # rubocop:enable Style/StringConcatenation

    file.close

    file
  end
end
