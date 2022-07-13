require "rails_helper"
require "securerandom"

RSpec.describe "Unaccompanied minor expression of interest", type: :system do
  before do
    driven_by(:rack_test_user_agent)
  end

<<<<<<< HEAD
  describe "start page" do
    it "sponsor url shows page" do
      visit "/sponsor-a-child"
      expect(page).to have_content("Sponsor a child fleeing Ukraine without a parent")
=======
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
<<<<<<< HEAD
>>>>>>> bb4ce52... Add WIP test for cancelling an application
=======

<<<<<<< HEAD
      # TODO set the expectation once the application reference is included in the flow
      # application = UnaccompaniedMinor.order("created_at DESC").last
      # expect(application.is_cancelled).to eq(true)
>>>>>>> 41e29f3... Remove expectation
=======
      cancelled_application = UnaccompaniedMinor.find(id)
      expect(cancelled_application).to eq(new_application)
      expect(cancelled_application.reference).to eq(test_reference)
      expect(cancelled_application.certificate_reference).to start_with("CERT-")
      expect(cancelled_application.is_cancelled).to eq(true)
    end

    it "redirects to confirm if already cancelled", :focus do
      answers = { is_eligible: "yes" }
      test_reference = sprintf("SPON-%<ref>s", ref: SecureRandom.uuid[9, 11].upcase)
      id = ActiveRecord::Base.connection.insert("INSERT INTO unaccompanied_minors (reference, answers, created_at, updated_at, is_cancelled) VALUES ('#{test_reference}', '#{JSON.generate(answers)}', NOW(), NOW(), TRUE)")

      new_application = UnaccompaniedMinor.find(id)
      expect(new_application.reference).to eq(test_reference)
      expect(new_application.certificate_reference).to start_with("CERT-")
      expect(new_application.is_cancelled).to be(true)

      page_url = "/unaccompanied-minor/task-list/#{test_reference}"
<<<<<<< HEAD
      expect(page_url).to end_with("test_reference")
>>>>>>> 7724cba... *****WIP*****
=======
      expect(page_url).to end_with(test_reference)

      visit page_url

      click_button("Cancel application")
      expect(page).to have_content("Your application has been cancelled")
>>>>>>> 3ca33b7... Amend controller to redirect when application already cancelled
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

    # it "saves all of the answers in the database" do
    #   visit "/unaccompanied-minor/check"
    #   expect(page).to have_content("Check if you can use this service")

    #   click_link("Continue")

    #   fill_in("What is the name of the child you want to sponsor?", with: "John Smith")
    #   click_button("Continue")

    #   fill_in("Day", with: "15")
    #   fill_in("Month", with: "6")
    #   fill_in("Year", with: "2017")
    #   click_button("Continue")

    #   expect(page).to have_content("Have you received both parental consent forms for John Smith?")
    #   choose("Yes")
    #   click_button("Continue")

    #   expect(page).to have_content("Upload the UK local authority parental consent form for John Smith")

    #   test_file_path = File.join(File.dirname(__FILE__), "..", "uk-test-document.pdf")

    #   Rails.logger.debug File.exist? test_file_path

    #   attach_file("unaccompanied-minor-uk-parental-consent-field", test_file_path)
    #   click_button("Upload")

    #   expect(page).to have_content("Upload the Ukraine parental consent form for John Smith")

    #   test_file_path = File.join(File.dirname(__FILE__), "..", "ukraine-test-document.pdf")

    #   Rails.logger.debug File.exist? test_file_path

    #   attach_file("unaccompanied-minor-ukraine-parental-consent-field", test_file_path)
    #   click_button("Upload")

    #   fill_in("What is your name?", with: "Jane Doe")
    #   click_button("Continue")

    #   fill_in("What is your email address?", with: "jane.doe@test.com")
    #   click_button("Continue")

    #   fill_in("What is your telephone number?", with: "07777 888 999")
    #   click_button("Continue")

    #   fill_in("Address line 1", with: "House number and Street name")
    #   fill_in("Town", with: "Some Town or City")
    #   fill_in("Postcode", with: "XX1 1XX")
    #   click_button("Continue")

    #   fill_in("Day", with: "6")
    #   fill_in("Month", with: "11")
    #   fill_in("Year", with: "1987")
    #   click_button("Continue")

    #   page.check("unaccompanied-minor-agree-privacy-statement-true-field")
    #   click_button("Continue")

    #   expect(page).to have_content("Child name John Smith")
    #   expect(page).to have_content("Child DoB 15 June 2017")
    #   expect(page).to have_content("Parental consent Yes")
    #   expect(page).to have_content("UK consent uk-test-document.pdf")
    #   expect(page).to have_content("Ukraine consent ukraine-test-document.pdf")
    #   expect(page).to have_content("Name Jane Doe")
    #   expect(page).to have_content("Email jane.doe@test.com")
    #   expect(page).to have_content("Telephone number 07777 888 999")
    #   expect(page).to have_content("Residential address House number and Street name")
    #   expect(page).to have_content("Sponsor DoB 6 November 1987")
    #   expect(page).to have_content("Privacy statement Agreed")

    #   click_button("Accept and send")

    #   expect(page).to have_content("Application complete")
    #   expect(page).to have_content("We've sent your application to your local council.")

    #   application = UnaccompaniedMinor.order("created_at DESC").last
    #   expect(application.as_json).to include({
    #     minor_fullname: "John Smith",
    #     minor_date_of_birth: { "1" => 2017, "2" => 6, "3" => 15 },
    #     have_parental_consent: "yes",
    #     uk_parental_consent_filename: "uk-test-document.pdf",
    #     uk_parental_consent_file_type: "application/pdf",
    #     ukraine_parental_consent_filename: "ukraine-test-document.pdf",
    #     ukraine_parental_consent_file_type: "application/pdf",
    #     fullname: "Jane Doe",
    #     email: "jane.doe@test.com",
    #     phone_number: "07777 888 999",
    #     residential_line_1: "House number and Street name",
    #     residential_town: "Some Town or City",
    #     residential_postcode: "XX1 1XX",
    #     sponsor_date_of_birth: { "1" => 1987, "2" => 11, "3" => 6 },
    #     agree_privacy_statement: "true",
    #   })

    #   expect(application.reference).not_to be_nil
    #   expect(application.reference).to start_with("SPON-")
    #   expect(application.certificate_reference).not_to be_nil
    #   expect(application.certificate_reference).to start_with("CERT-")
    #   expect(application.certificate_reference).to match(/CERT-[A-Z]{4}-[0-9]{4}-[A-Z]/)
    #   expect(application.ip_address).to eq("127.0.0.1")
    #   expect(application.user_agent).to eq("DummyBrowser")
    #   expect(application.started_at).to match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.\d*Z/)
    # end
  end
end
