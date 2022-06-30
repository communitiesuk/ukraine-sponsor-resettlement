require "rails_helper"

RSpec.describe "Unaccompanied minor expression of interest", type: :system do
  before do
    driven_by(:rack_test_user_agent)
  end

  describe "submitting the form" do
    it "without parental consent form terminates early" do
      visit "/unaccompanied-minor"
      expect(page).to have_content("Apply for certification to sponsor a child travelling on their own")

      click_link("Start now")

      fill_in("What is the name of the child you want to sponsor?", with: "John Smith")
      click_button("Continue")

      fill_in("Day", with: "15")
      fill_in("Month", with: "6")
      fill_in("Year", with: "2017")
      click_button("Continue")

      expect(page).to have_content("Have you received both parental consent forms for John Smith?")
      choose("No")
      click_button("Continue")

      expect(page).to have_content("You cannot apply without completed parental consent forms")
    end

    it "saves all of the answers in the database", :focus do
      visit "/unaccompanied-minor"
      expect(page).to have_content("Apply for certification to sponsor a child travelling on their own")

      click_link("Start now")

      fill_in("What is the name of the child you want to sponsor?", with: "John Smith")
      click_button("Continue")

      fill_in("Day", with: "15")
      fill_in("Month", with: "6")
      fill_in("Year", with: "2017")
      click_button("Continue")

      expect(page).to have_content("Have you received both parental consent forms for John Smith?")
      choose("Yes")
      click_button("Continue")

      expect(page).to have_content("Upload the UK local authority parental consent form for John Smith")

      test_file_path = File.join(File.dirname(__FILE__), "..", "uk-test-document.pdf")

      Rails.logger.debug File.exist? test_file_path

      attach_file("unaccompanied-minor-uk-parental-consent-field", test_file_path)
      click_button("Upload")

      fill_in("What is your name?", with: "Jane Doe")
      click_button("Continue")

      fill_in("What is your email address?", with: "jane.doe@test.com")
      click_button("Continue")

      fill_in("What is your telephone number?", with: "07777 888 999")
      click_button("Continue")

      fill_in("Address line 1", with: "House number and Street name")
      fill_in("Town", with: "Some Town or City")
      fill_in("Postcode", with: "XX1 1XX")
      click_button("Continue")

      fill_in("Day", with: "6")
      fill_in("Month", with: "11")
      fill_in("Year", with: "1987")
      click_button("Continue")

      page.check("unaccompanied-minor-agree-privacy-statement-true-field")
      click_button("Continue")

      expect(page).to have_content("Child name John Smith")
      expect(page).to have_content("Child DoB 15 June 2017")
      expect(page).to have_content("Parental consent Yes")
      expect(page).to have_content("Consent uk-test-document.pdf")
      expect(page).to have_content("Name Jane Doe")
      expect(page).to have_content("Email jane.doe@test.com")
      expect(page).to have_content("Telephone number 07777 888 999")
      expect(page).to have_content("Residential address House number and Street name")
      expect(page).to have_content("Sponsor DoB 6 November 1987")
      expect(page).to have_content("Privacy statement Agreed")

      click_button("Accept and send")

      expect(page).to have_content("Application complete")
      expect(page).to have_content("We've sent your application to your local council.")

      application = UnaccompaniedMinor.order("created_at DESC").last
      expect(application.as_json).to include({
        minor_fullname: "John Smith",
        minor_date_of_birth: { "1" => 2017, "2" => 6, "3" => 15 },
        have_parental_consent: "yes",
        uk_parental_consent_filename: "uk-test-document.pdf",
        uk_parental_consent_file_type: "application/pdf",
        fullname: "Jane Doe",
        email: "jane.doe@test.com",
        phone_number: "07777 888 999",
        residential_line_1: "House number and Street name",
        residential_town: "Some Town or City",
        residential_postcode: "XX1 1XX",
        sponsor_date_of_birth: { "1" => 1987, "2" => 11, "3" => 6 },
        agree_privacy_statement: "true",
      })

      expect(application.reference).not_to be_nil
      expect(application.reference).to start_with("SPON-")
      expect(application.certificate_reference).not_to be_nil
      expect(application.certificate_reference).to start_with("CERT-")
      expect(application.ip_address).to eq("127.0.0.1")
      expect(application.user_agent).to eq("DummyBrowser")
      expect(application.started_at).to match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.\d*Z/)
    end
  end
end
