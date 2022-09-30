module UnaccompaniedMinorHelpers
  def uam_complete_eligibity_section
    visit "/sponsor-a-child/start"
    expect(page).to have_content("Apply to provide a safe home for a child from Ukraine")

    click_link("Start now")

    expect(page).to have_content("Check if you are eligible to use this service")

    click_link("Continue")

    # step 1
    expect(page).to have_content("Is the child you want to sponsor under 18?")
    choose("Yes")
    click_button("Continue")

    # step 2
    expect(page).to have_content("Was the child living in Ukraine on or before 31 December 2021?")
    choose("Yes")
    click_button("Continue")

    # step 3 is skipped in this instance

    # step 4
    expect(page).to have_content("Are they travelling to the UK with a parent or legal guardian?")
    choose("No")
    click_button("Continue")

    # step 5
    expect(page).to have_content("Can you upload both consent forms?")
    choose("Yes")
    click_button("Continue")

    # step 6
    expect(page).to have_content("Can you commit to hosting the child for the minimum period?")
    choose("Yes")
    click_button("Continue")

    # step 7
    expect(page).to have_content("Do you have permission to live in the UK for the minimum period?")
    choose("Yes")
    click_button("Continue")

    expect(page).to have_content("You are eligible to use this service")
  end

  def uam_start_page_to_task_list
    click_link("Start application")
    # let(:task_list_content) { "Apply for approval to provide a safe home for a child from Ukraine" }
    expect(page).to have_content("Apply for approval to provide a safe home for a child from Ukraine")
  end

  def uam_enter_sponsor_name(given: "Jane", family: "Sponsor", click_continue: true)
    click_link("Name")
    expect(page).to have_content("Enter your name")

    fill_in_name(given, family, click_continue:)

    if click_continue
      expect(page).to have_content("Have you ever been known by another name?")
    end
  end

  def fill_in_name(given, family, click_continue: true)
    fill_in("Given names", with: given)
    fill_in("Family name", with: family)

    if click_continue
      click_button("Continue")
    end
  end
end
