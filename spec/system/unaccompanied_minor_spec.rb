require "rails_helper"
require "securerandom"

RSpec.describe "Unaccompanied minor expression of interest", type: :system do
  before do
    driven_by(:rack_test_user_agent)
  end

  describe "start page" do
    it "sponsor url shows page" do
      visit "/sponsor-a-child"
      expect(page).to have_content("Sponsor a child fleeing Ukraine without a parent")
    end
  end

  describe "cancelling the application" do
    it "updates the application as cancelled" do
      answers = { fullname: "Bob The Builder" }
      test_reference = sprintf("SPON-%<ref>s", ref: SecureRandom.uuid[9, 11].upcase)
      id = ActiveRecord::Base.connection.insert("INSERT INTO unaccompanied_minors (reference, answers, created_at, updated_at, is_cancelled) VALUES ('#{test_reference}', '#{JSON.generate(answers)}', NOW(), NOW(), false)")

      new_application = UnaccompaniedMinor.find(id)
      expect(new_application.reference).to eq(test_reference)
      expect(new_application.certificate_reference).to start_with("CERT-")
      expect(new_application.is_cancelled).to be(false)

      page_url = "/unaccompanied-minor/task-list/#{new_application.reference}"
      expect(page_url).to end_with(new_application.reference)

      visit page_url
      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")

      click_button("Cancel application")
      expect(page).to have_content("Are you sure you want to cancel your application?")

      click_button("Cancel application")
      expect(page).to have_content("Your application has been cancelled")

      cancelled_application = UnaccompaniedMinor.find(id)
      expect(cancelled_application).to eq(new_application)
      expect(cancelled_application.reference).to eq(test_reference)
      expect(cancelled_application.certificate_reference).to start_with("CERT-")
      expect(cancelled_application.is_cancelled).to eq(true)
    end

    it "render cancellation confirmation on task list if already cancelled" do
      answers = { is_eligible: "yes" }
      test_reference = sprintf("SPON-%<ref>s", ref: SecureRandom.uuid[9, 11].upcase)
      id = ActiveRecord::Base.connection.insert("INSERT INTO unaccompanied_minors (reference, answers, created_at, updated_at, is_cancelled) VALUES ('#{test_reference}', '#{JSON.generate(answers)}', NOW(), NOW(), TRUE)")

      new_application = UnaccompaniedMinor.find(id)
      expect(new_application.reference).to eq(test_reference)
      expect(new_application.certificate_reference).to start_with("CERT-")
      expect(new_application.is_cancelled).to be(true)

      page_url = "/unaccompanied-minor/task-list/#{test_reference}"
      expect(page_url).to end_with(test_reference)

      visit page_url
      expect(page).to have_content("Your application has been cancelled")
    end

    it "redirect to task list if user decides to continue application" do
      answers = { fullname: "Bob The Builder" }
      test_reference = sprintf("SPON-%<ref>s", ref: SecureRandom.uuid[9, 11].upcase)
      id = ActiveRecord::Base.connection.insert("INSERT INTO unaccompanied_minors (reference, answers, created_at, updated_at, is_cancelled) VALUES ('#{test_reference}', '#{JSON.generate(answers)}', NOW(), NOW(), false)")

      new_application = UnaccompaniedMinor.find(id)
      expect(new_application.reference).to eq(test_reference)
      expect(new_application.certificate_reference).to start_with("CERT-")
      expect(new_application.is_cancelled).to be(false)

      page_url = "/unaccompanied-minor/task-list/#{new_application.reference}"
      expect(page_url).to end_with(new_application.reference)

      visit page_url
      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")

      click_button("Cancel application")
      expect(page).to have_content("Are you sure you want to cancel your application?")

      click_button("Continue application")
      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")

      continued_application = UnaccompaniedMinor.find(id)
      expect(continued_application).to eq(new_application)
      expect(continued_application.reference).to eq(test_reference)
      expect(continued_application.certificate_reference).to start_with("CERT-")
      expect(continued_application.is_cancelled).to eq(false)
    end
  end

  describe "submitting the form" do
    it "shows the guidance page before the start page" do
      visit "/unaccompanied-minor/"
      expect(page).to have_content("Sponsor a child fleeing Ukraine without a parent")

      click_link("Apply for permission to sponsor an unaccompanied child fleeing Ukraine")

      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")
    end

    it "shows check if eligible for this service page" do
      visit "/unaccompanied-minor/start"
      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")

      click_link("Start now")

      expect(page).to have_content("Check if you can use this service")
    end

    it "shows the user uneligible page if they answer NO to any question" do
      visit "/unaccompanied-minor/steps/1"

      # step 1
      expect(page).to have_content("Is the child you want to sponsor under 18?")
      choose("No")
      click_button("Continue")

      expect(page).to have_content("You cannot use this service")
    end

    it "takes the user to the end of eligibility path" do
      visit "/unaccompanied-minor/start"
      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")

      click_link("Start now")

      expect(page).to have_content("Check if you can use this service")

      click_link("Continue")

      # step 1
      expect(page).to have_content("Is the child you want to sponsor under 18?")
      choose("Yes")
      click_button("Continue")

      # step 2
      expect(page).to have_content("Were they living in Ukraine on 31 December 2021?")
      choose("Yes")
      click_button("Continue")

      # step 3 is skipped in this instance

      # step 4
      expect(page).to have_content("Are they travelling to the UK with a parent or legal guardian?")
      choose("Yes")
      click_button("Continue")

      # step 5
      expect(page).to have_content("Do they have a parent or legal guardian that can provide written consent?")
      choose("Yes")
      click_button("Continue")

      # step 6
      expect(page).to have_content("Are you a British citizen?")
      choose("Yes")
      click_button("Continue")

      # step 7 is skipped in this case

      # step 8
      expect(page).to have_content("Can you commit to caring for the children until they are 18 or for at least 3 years?")
      choose("Yes")
      click_button("Continue")

      # step 9
      expect(page).to have_content("You can use this service")
    end

    it "shows eligibility question 3 if 2 is answered NO" do
      visit "/unaccompanied-minor/steps/2"

      # step 2
      expect(page).to have_content("Were they living in Ukraine on 31 December 2021?")
      choose("No")
      click_button("Continue")

      # step 3
      expect(page).to have_content("Was the child born after 31 December 2021?")
    end

    it "shows eligibility question 7 if 6 is answered NO" do
      visit "/unaccompanied-minor/steps/6"

      # step 6
      expect(page).to have_content("Are you a British citizen?")
      choose("No")
      click_button("Continue")

      # step 7
      expect(page).to have_content("To sponsor a child you must have the right to live in the UK for a minimum of")
    end

    it "saves all of the answers in the database" do
      # step 8 - only to set is_eligible = true
      visit "/unaccompanied-minor/steps/8"
      expect(page).to have_content("Can you commit to caring for the children until they are 18 or for at least 3 years?")
      choose("Yes")
      click_button("Continue")

      # skip step 9 - just a mini confirmation screen

      # steps 10 - 22 -> sponsor details form

      # step 10 - sponsor name
      visit "/unaccompanied-minor/steps/10"
      fill_in("What is your name?", with: "Jane Doe")
      click_button("Continue")

      # step 11 - other names
      expect(page).to have_content("Have you ever been known by another name?")
      choose("No")
      click_button("Continue")

      # step 14 - email address
      fill_in("What is your email address?", with: "jane.doe@test.com")
      click_button("Continue")

      # step 15 - UK telephone number
      fill_in("What is your UK telephone number?", with: "07777 888 999")
      click_button("Continue")

      # step 16 - ID
      expect(page).to have_content("Do you have any of these identity documents?")
      page.check("unaccompanied-minor-identification-type-passport-field")
      click_button("Continue")

      # Step 18 - Date of birth
      fill_in("Day", with: "6")
      fill_in("Month", with: "11")
      fill_in("Year", with: "1987")
      click_button("Continue")

      # Step 19 - Nationality
      click_button("Continue")

      # Step 20 - Other nationality
      expect(page).to have_content("Have you ever held any other nationalities?")
      choose("No")
      click_button("Continue")
    end

    ### THE FOLLOWING TESTS MIGHT BE OBSOLETE AND WILL NEED REFACTORING ###

    # it "without parental consent form terminates early" do
    #   visit "/unaccompanied-minor/check"
    #   expect(page).to have_content("Check if you can use this service")

    #   click_link("Continue")

    #   choose("Yes")
    #   click_button("Continue")

    #   fill_in("What is the name of the child you want to sponsor?", with: "John Smith")
    #   click_button("Continue")

    #   fill_in("Day", with: "15")
    #   fill_in("Month", with: "6")
    #   fill_in("Year", with: "2017")
    #   click_button("Continue")

    #   expect(page).to have_content("Have you received both parental consent forms for John Smith?")
    #   choose("No")
    #   click_button("Continue")

    #   expect(page).to have_content("You cannot apply without completed parental consent forms")
    # end
  end
end
