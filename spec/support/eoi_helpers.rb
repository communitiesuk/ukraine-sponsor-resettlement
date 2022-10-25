module EoiHelpers
  START_PAGE_CONTENT = "People from Ukraine living in the UK need new homes now".freeze

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

  def eoi_enter_sponsor_name(name: "Spencer Graham")
    expect(page).to have_content("Enter your full name")

    fill_in("Enter your full name", with: name)
    click_on("Continue")

    expect(page).to have_content("Enter your email address")
  end

  def eoi_enter_sponsor_contact_details(email: "spencer.sponsor@example.com", phone_number: "07123123123")
    expect(page).to have_content("Enter your email address")
    fill_in("Enter your email address", with: email)
    click_on("Continue")

    expect(page).to have_content("Enter your contact telephone number")

    fill_in("Enter your contact telephone number", with: phone_number)

    click_on("Continue")
  end

  def eoi_enter_sponsor_address(different_address: false, more_properties: false)
    expect(page).to have_content("This is the address where you live")
    eoi_enter_address

    expect(page).to have_content("Is the property you’re offering at a different address to your home?")

    if different_address
      eoi_choose_option("Yes")

      expect(page).to have_content("Enter the address of the property you're offering")

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

    expect(page).to have_content("How soon can you start hosting someone?")
  end

  def eoi_enter_sponsor_start(date: Time.zone.now + 1.year)
    choose("Specific date")
    fill_in("Day", with: date.day)
    fill_in("Month", with: date.month)
    fill_in("Year", with: date.year)

    click_on("Continue")
  end

  def eoi_people_at_address(adult_number: "2", child_number: "3")
    expect(page).to have_content("How many people normally live in the property you’re offering (not including guests)?")

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

    expect(page).to have_content("How many bedrooms are available for guests in the property you’re registering now?")
  end

  def eoi_number_of_rooms(single: 6, double: 3)
    expect(page).to have_content("How many bedrooms are available for guests in the property you’re registering now?")

    fill_in("expression-of-interest-single-room-count-field", with: single)
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

    expect(page).to have_content("Would you like to take part in research to help us improve the Homes for Ukraine service?")
  end

  def eoi_contact_consent(research: "Yes")
    expect(page).to have_content("Would you like to take part in research to help us improve the Homes for Ukraine service?")

    eoi_choose_option(research)

    expect(page).to have_content("Confirm you have read the privacy statement and agree that the information you have provided in this form can be used for the Homes for Ukraine scheme")

    check("Yes, I have read the privacy statement and agree that the information I have provided in this form can be used for the Homes for Ukraine scheme")
    click_on("Continue")

    expect(page).to have_content("Check your answers before sending your registration")
  end

  def eoi_check_answers_and_submit
    expect(page).to have_content("Check your answers before sending your registration")

    click_on("Accept and send")

    expect(page).to have_content("EOI-")
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
end
