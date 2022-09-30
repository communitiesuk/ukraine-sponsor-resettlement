module UnaccompaniedMinorHelpers
  START_PAGE_CONTENT = "You are eligible to use this service".freeze
  TASK_LIST_CONTENT = "Apply for approval to provide a safe home for a child from Ukraine".freeze
  SPONSOR_OTHER_NAME_CONTENT = "Have you ever been known by another name?".freeze

  def uam_complete_eligibity_section
    visit "/sponsor-a-child/start"
    expect(page).to have_content("Apply to provide a safe home for a child from Ukraine")

    click_link("Start now")

    expect(page).to have_content("Check if you are eligible to use this service")

    click_link("Continue")

    # step 1
    expect(page).to have_content("Is the child you want to sponsor under 18?")
    uam_choose_option("Yes")

    # step 2
    expect(page).to have_content("Was the child living in Ukraine on or before 31 December 2021?")
    uam_choose_option("Yes")

    # step 3 is skipped in this instance

    # step 4
    expect(page).to have_content("Are they travelling to the UK with a parent or legal guardian?")
    uam_choose_option("No")

    # step 5
    expect(page).to have_content("Can you upload both consent forms?")
    uam_choose_option("Yes")

    # step 6
    expect(page).to have_content("Can you commit to hosting the child for the minimum period?")
    uam_choose_option("Yes")

    # step 7
    expect(page).to have_content("Do you have permission to live in the UK for the minimum period?")
    uam_choose_option("Yes")

    expect(page).to have_content(START_PAGE_CONTENT)
  end

  def uam_start_page_to_task_list
    expect(page).to have_content(START_PAGE_CONTENT)
    click_link("Start application")
    expect(page).to have_content(TASK_LIST_CONTENT)
  end

  def uam_enter_sponsor_name(given: "Jane", family: "Sponsor", click_continue: true)
    click_link("Name") #### DONT LIKE THIS HERE NEIL
    expect(page).to have_content("Enter your name")

    fill_in_name(given, family, click_continue:)

    if click_continue
      expect(page).to have_content(SPONSOR_OTHER_NAME_CONTENT)
    end
  end

  def uam_sponsor_known_by_another_name(option = "No", click_continue: true)
    expect(page).to have_content(SPONSOR_OTHER_NAME_CONTENT)

    uam_choose_option(option, click_continue:)

    if click_continue && option == "No"
      expect(page).to have_content(TASK_LIST_CONTENT)
    end
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
end
