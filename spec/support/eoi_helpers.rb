module EoiHelpers
  START_PAGE_CONTENT = "People from Ukraine living in the UK need new homes now".freeze
  TASK_LIST_CONTENT = "Apply for approval to provide a safe home for a child from Ukraine".freeze
  SPONSOR_OTHER_NAME_CONTENT = "Have you ever been known by another name?".freeze

  def eoi_enter_valid_complete_self_assessment_section

    visit "/expression-of-interest/self-assessment/start"
    
    expect(page).to have_content(START_PAGE_CONTENT)

    click_on("Start now")

    expect(page).to have_content("Is your property suitable for hosting?")
    page.execute_script("$('#self_assesment_navigation')")

    eoi_choose_option("Yes")

    expect(page).to have_content("There are some challenges")

    # eoi_choose_option("Yes")

    # expect(page).to have_content("Enter your full name")
  end

  def eoi_skip_to_questions
    visit "/expression-of-interest/steps/1"
  end

  def eoi_enter_sponsor_name(name: "Spencer Graham", click_continue: true)
    expect(page).to have_content("Enter your full name")

    fill_in("Enter your full name", with: name)
    click_on("Continue")
    if click_continue
      expect(page).to have_content("Enter your email address")
    end
  end

  def eoi_enter_sponsor_not_known_by_another_name(click_continue: true)
    expect(page).to have_content(SPONSOR_OTHER_NAME_CONTENT)

    eoi_choose_option("No", click_continue:)

    if click_continue
      expect(page).to have_content(TASK_LIST_CONTENT)
    end
  end

  def eoi_enter_sponsor_other_name
    expect(page).to have_content(SPONSOR_OTHER_NAME_CONTENT)

    eoi_choose_option("Yes")
    fill_in_name("Another", "Sponsor", click_continue: true)

    expect(page).to have_content("You have added")
    click_on("Continue")

    expect(page).to have_content(TASK_LIST_CONTENT)
  end

  def eoi_enter_sponsor_contact_details(email: "spencer.sponsor@example.com", phone_number: "07123123123" )
    
    expect(page).to have_content("Enter your email address")
    fill_in("Enter your email address", with: email)
    click_on("Continue")

    expect(page).to have_content("Enter your contact telephone number")

    fill_in("Enter your contact telephone number", with: phone_number)
    
    click_on("Continue")
  end

  def eoi_enter_sponsor_identity_documents(option)
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

  def eoi_enter_sponsor_additional_details(
    id_option: "Passport",
    nationality: "Denmark", other_nationalities: []
  )
    eoi_enter_sponsor_identity_documents(id_option)

    expect(page).to have_content("Enter your date of birth")
    eoi_fill_in_date_of_birth(Time.zone.now - 21.years)

    eoi_enter_sponsor_nationalities(nationality:, other_nationalities:)

    expect(page).to have_content(TASK_LIST_CONTENT)
  end

  def eoi_enter_sponsor_nationalities(nationality: "Denmark", other_nationalities: nil)
    expect(page).to have_content("Enter your nationality")

    select(nationality, from: "unaccompanied-minor-nationality-field")
    click_on("Continue")

    expect(page).to have_content("Have you ever held any other nationalities?")

    if other_nationalities.blank?
      eoi_choose_option("No")
    else
      eoi_choose_option("Yes")

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

  def eoi_enter_sponsor_address(different_address: false, more_properties: false)
    expect(page).to have_content("This is the address where you live")
    eoi_enter_address

    expect(page).to have_content("Is the property you’re offering at a different address to your home?")

    if different_address
      eoi_choose_option("Yes")

      expect(page).to have_content("Enter the address of the property you’re offering")
      
      eoi_enter_address(line1: "Child Address line 1", town: "Child Town", postcode: "CH1 1LD")

      expect(page).to have_content("Are you offering any more properties?")

      if more_properties
        eoi_choose_option("Yes")
        
        expect(page).to have_content("You will be able to share information about any more properties you have to offer when your local authority contacts you")

        click_on("Continue")
      else 
        eoi_choose_option("No")
      end
    else 
      eoi_choose_option("No")
    end

    expect(page).to have_content("How many people will be living at the address you’re offering (not including guests)?")
  end

  def eoi_people_at_address(adult_number: "2", child_number: "3")
    expect(page).to have_content("How many people will be living at the address you’re offering (not including guests)?")

    fill_in("Adults", with: adult_number)
    fill_in("Children", with: child_number)

    click_on("Continue")
    expect(page).to have_content("Who would you like to offer accommodation to?")

  end

  def eoi_enter_address(line1: "Address line 1", line2: nil, town: "Town", postcode: "XX1 1XX")
    fill_in("Address line 1", with: line1)

    if line2.present?
      fill_in("Address line 2", with: line2)
    end

    fill_in("Town", with: town)
    fill_in("Postcode", with: postcode)

    click_on("Continue")
  end

  def eoi_sponsor_refugee_preference(type: "Single adult")
    expect(page).to have_content("Who would you like to offer accommodation to?")

    choose(type)
    click_on("Continue")

    expect(page).to have_content("How long can you offer accommodation for?")
  end

  def eoi_sponsorship_length(time: "From 6 to 9 months")
    expect(page).to have_content("How long can you offer accommodation for?")

    choose(time)
    click_on("Continue")
    expect(page).to have_content("How many single rooms do you have available in the property you have specified?")
  end
  
  def eoi_number_of_rooms(single: 6, double: 3)
    expect(page).to have_content("How many single rooms do you have available in the property you have specified?")

    fill_in("expression-of-interest-single-room-count-field", with: single)
    click_on("Continue")

    expect(page).to have_content("How many double bedrooms (or larger) do you have available in the property you have specified?")

    fill_in("expression-of-interest-double-room-count-field", with: double)
    click_on("Continue")

    expect(page).to have_content("Does the property, or any of the properties, have step-free access?")
  end

  def eoi_accessibility_info(step_free: "Yes, all", pets: "Yes")
    expect(page).to have_content("Does the property, or any of the properties, have step-free access?")
    choose(step_free)
    click_on("Continue")

    expect(page).to have_content("Would you consider allowing guests to bring their pets?")
    
    choose(pets)
    click_on("Continue")

    expect(page).to have_content("Can we contact you about your registration?")
  end
  
  def eoi_contact_consent(research: "Yes")
    expect(page).to have_content("Can we contact you about your registration?")

    check("Can we contact you about your registration?")
    click_on("Continue")

    expect(page).to have_content("Would you like to take part in research to help us improve the Homes for Ukraine service?")

    choose(research)
    click_on("Continue")

    expect(page).to have_content("Confirm you have read the privacy statement and agree that the information you have provided in this form can be used for the Homes for Ukraine scheme")

    check("Yes, I have read the privacy statement and agree that the information I have provided in this form can be used for the Homes for Ukraine scheme")
    click_on("Continue")

    expect(page).to have_content("Check your answers before sending your registration")
  end
  
  def eoi_check_answers_and_submit
    expect(page).to have_content("Check your answers before sending your registration")

    find("button[type=submit]").click

    expect(page).to have_content("EOI-")
  end

  def fill_in_name(given, family, click_continue: true)
    fill_in("Given names", with: given)
    fill_in("Family name", with: family)

    if click_continue
      click_on("Continue")
    end
  end

  def eoi_fill_in_date_of_birth(date, click_continue: true)
    fill_in("Day", with: date.day)
    fill_in("Month", with: date.month)
    fill_in("Year", with: date.year)

    if click_continue
      click_on("Continue")
    end
  end

  def eoi_choose_option(choice, click_continue: true)
    choose(choice)

    if click_continue
      click_on("Continue")
    end
  end

  def eoi_enter_minors_contact_details(email: nil, confirm_email: nil, telephone: nil, confirm_telephone: nil, select_none: false, click_continue: true)
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
      click_on("Continue")
    end
  end

  def complete_eoi_individual_questions
    expect(page).to have_content("Enter your full name")
    fill_in(expression_of_interest[fullname], with: "Steve Jobs")

    expect(page).to have_content("Enter your email address")
    fill_in(expression_of_interest[email], with: "steve@example.com")

    expect(page).to have_content("Enter your contact telephone number")
    fill_in(expression_of_interest[phone_number], with: "07274658365")

    expect(page).to have_content("Can you commit to hosting the child for the minimum period?")
    eoi_choose_option("Yes")

    expect(page).to have_content("Do you have permission to live in the UK for the minimum period?")
    eoi_choose_option("Yes")
  end
end
