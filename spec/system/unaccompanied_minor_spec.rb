require "rails_helper"

RSpec.describe "Unaccompanied minor expression of interest", type: :system do
  before do
    driven_by(:rack_test_user_agent)
  end

  let(:task_list_content) { "Apply for approval to provide a safe home for a child from Ukraine" }
  let(:name_page_content) { "Enter your name".freeze }
  let(:other_adults_address_content) { "Enter the name of a person over 16 who will live with the child".freeze }
  let(:start_page_content) { "Apply to provide a safe home for a child from Ukraine" }
  let(:task_list_url) { "/sponsor-a-child/task-list" }

  describe "start page" do
    it "sponsor url shows page" do
      visit "/sponsor-a-child"
      expect(page).to have_content(start_page_content)
    end
  end

  describe "app_reference is checked in middleware" do
    it "can view the task list when app_reference is present" do
      new_application = UnaccompaniedMinor.new
      new_application.save!
      page.set_rack_session(app_reference: new_application.reference)
      visit task_list_url
      expect(page).to have_current_path(task_list_url)
      expect(page).to have_content(task_list_content)
    end

    it "redirected to sponsor-a-child when app_reference is not present" do
      visit task_list_url
      expect(page).to have_current_path("/sponsor-a-child")
    end
  end

  describe "cancelling the application" do
    it "updates the application as cancelled" do
      new_application = UnaccompaniedMinor.new
      new_application.save!

      expect(new_application.is_cancelled).to be(false)

      page.set_rack_session(app_reference: new_application.reference)

      visit task_list_url
      expect(page).to have_content(task_list_content)

      click_button("Cancel application")
      expect(page).to have_content("Are you sure you want to cancel your application?")

      click_button("Cancel application")
      expect(page).to have_content("Your application has been cancelled")

      cancelled_application = UnaccompaniedMinor.find_by_reference(new_application.reference)
      expect(cancelled_application.is_cancelled).to eq(true)
    end

    it "render cancellation confirmation on task list if already cancelled" do
      new_application = UnaccompaniedMinor.new
      new_application.is_cancelled = true
      new_application.save!

      expect(new_application.is_cancelled).to be(true)

      page.set_rack_session(app_reference: new_application.reference)

      visit task_list_url
      expect(page).to have_content("Your application has been cancelled")
    end

    it "render confirmation on task list if already submitted" do
      new_application = UnaccompaniedMinor.new
      new_application.transferred_at = Time.zone.now
      new_application.save!

      expect(new_application.transferred_at).not_to be_nil

      page.set_rack_session(app_reference: new_application.reference)

      visit task_list_url
      expect(page).to have_content("Application complete")
    end

    it "redirect to task list if user decides to continue application" do
      new_application = UnaccompaniedMinor.new
      new_application.save!

      expect(new_application.is_cancelled).to be(false)

      page.set_rack_session(app_reference: new_application.reference)

      visit task_list_url
      expect(page).to have_content(task_list_content)

      click_button("Cancel application")
      expect(page).to have_content("Are you sure you want to cancel your application?")

      click_button("Continue application")
      expect(page).to have_content(task_list_content)

      continued_application = UnaccompaniedMinor.find_by_reference(new_application.reference)
      expect(continued_application.is_cancelled).to eq(false)
    end
  end

  describe "User enters their details" do
    it "complete UAM sponsor name(s) section and save answers to the db" do
      new_application = UnaccompaniedMinor.new
      new_application.save!
      page.set_rack_session(app_reference: new_application.reference)
      visit task_list_url
      expect(page).to have_content(task_list_content)

      uam_click_task_list_link("Name")
      expect(page).to have_content(name_page_content)

      uam_enter_sponsor_name(given: "Jane", family: "Doe")
      uam_enter_sponsor_not_known_by_another_name
      uam_click_task_list_link("Name")

      expect(page).to have_field("Given names", with: "Jane")
      expect(page).to have_field("Family name", with: "Doe")
    end
  end

  describe "submitting the address for child" do
    it "submit the form when address is where the child is staying with the sponsor" do
      new_application = UnaccompaniedMinor.new
      new_application.save!

      page.set_rack_session(app_reference: new_application.reference)

      visit task_list_url
      expect(page).to have_content(task_list_content)

      click_link("Address")
      expect(page).to have_content("Enter the address where the child will be living in the UK")

      fill_in("Address line 1", with: "Address line 1")
      fill_in("Town", with: "Address town")
      fill_in("Postcode", with: "XX1 1XX")

      click_button("Continue")
      expect(page).to have_content("Will you be living at this address?")

      choose("Yes")
      click_button("Continue")

      expect(page).to have_content("Will anyone else over the age of 16 be living at this address?")

      choose("No")
      click_button("Continue")

      expect(page).to have_content(task_list_content)
    end

    it "submit the form when address is where the child is NOT staying with the sponsor" do
      new_application = UnaccompaniedMinor.new
      new_application.save!

      page.set_rack_session(app_reference: new_application.reference)

      visit task_list_url
      expect(page).to have_content(task_list_content)

      click_link("Address")
      expect(page).to have_content("Enter the address where the child will be living in the UK")

      fill_in("Address line 1", with: "Address line 1")
      fill_in("Town", with: "Address town")
      fill_in("Postcode", with: "XX1 1XX")

      click_button("Continue")
      expect(page).to have_content("Will you be living at this address?")

      choose("No")
      click_button("Continue")

      expect(page).to have_content("Enter the address where you will be living in the UK")

      fill_in("Address line 1", with: "Sponsor address line 1")
      fill_in("Address line 2 (optional)", with: "Sponsor address line 2")
      fill_in("Town", with: "Sponsor address town")
      fill_in("Postcode", with: "XX1 1XX")

      click_button("Continue")
      expect(page).to have_content(other_adults_address_content)

      fill_in_name("Another", "Adult")

      expect(page).to have_content("You have added 1 person over 16 who will live with the child")
      expect(page).to have_content("Another Adult")
    end

    it "when multiple over 16 year olds are staying at the address" do
      new_application = UnaccompaniedMinor.new
      new_application.save!

      page.set_rack_session(app_reference: new_application.reference)

      visit task_list_url
      expect(page).to have_content(task_list_content)

      click_link("Address")
      expect(page).to have_content("Enter the address where the child will be living in the UK")

      fill_in("Address line 1", with: "Address line 1")
      fill_in("Town", with: "Address town")
      fill_in("Postcode", with: "XX1 1XX")

      click_button("Continue")
      expect(page).to have_content("Will you be living at this address?")

      choose("No")
      click_button("Continue")

      expect(page).to have_content("Enter the address where you will be living in the UK")

      fill_in("Address line 1", with: "Sponsor address line 1")
      fill_in("Address line 1", with: "Sponsor address line 2")
      fill_in("Town", with: "Sponsor address town")
      fill_in("Postcode", with: "XX1 1XX")

      click_button("Continue")
      expect(page).to have_content(other_adults_address_content)

      fill_in_name("First", "Adult")

      expect(page).to have_content("You have added 1 person over 16 who will live with the child")
      expect(page).to have_content("First Adult")

      click_link("Add another person")
      expect(page).to have_content(other_adults_address_content)

      fill_in_name("Second", "Adult")

      expect(page).to have_content("You have added 2 people over 16 who will live with the child")
      expect(page).to have_content("Second Adult")
    end

    it "when single over 16 year olds are staying at the address and is removed" do
      new_application = UnaccompaniedMinor.new
      new_application.save!

      page.set_rack_session(app_reference: new_application.reference)

      visit task_list_url
      expect(page).to have_content(task_list_content)

      click_link("Address")
      expect(page).to have_content("Enter the address where the child will be living in the UK")

      fill_in("Address line 1", with: "Address line 1")
      fill_in("Town", with: "Address town")
      fill_in("Postcode", with: "XX1 1XX")

      click_button("Continue")
      expect(page).to have_content("Will you be living at this address?")

      choose("No")
      click_button("Continue")

      expect(page).to have_content("Enter the address where you will be living in the UK")

      fill_in("Address line 1", with: "Sponsor address line 1")
      fill_in("Address line 1", with: "Sponsor address line 2")
      fill_in("Town", with: "Sponsor address town")
      fill_in("Postcode", with: "XX1 1XX")

      click_button("Continue")
      expect(page).to have_content(other_adults_address_content)

      fill_in_name("First", "Adult")

      expect(page).to have_content("You have added 1 person over 16 who will live with the child")
      expect(page).to have_content("First Adult")

      click_link("Remove")
      expect(page).to have_content(other_adults_address_content)
    end
  end

  describe "task list dynamic elements" do
    it "correctly numbers the headings" do
      new_application = UnaccompaniedMinor.new
      new_application.save!

      page.set_rack_session(app_reference: new_application.reference)

      visit task_list_url
      expect(page).not_to have_content("3. Residents' details")
      expect(page).to have_content("3. Child's details")
      expect(page).to have_content("4. Send your application")

      new_application.adults_at_address = {}
      new_application.adults_at_address.store("123", Adult.new("Bob", "Jones", "dob", "nationality", "id_and_type"))
      new_application.save!

      visit task_list_url
      expect(page).to have_content("3. Residents' details")
      expect(page).to have_content("4. Child's details")
      expect(page).to have_content("5. Send your application")
    end

    it "correctly shows the resident details task items" do
      new_application = UnaccompaniedMinor.new
      new_application.adults_at_address = {}
      new_application.adults_at_address.store("123", Adult.new("Bob", "Jones", "dob", "nationality", "id_and_type"))
      new_application.save!

      page.set_rack_session(app_reference: new_application.reference)

      visit task_list_url
      expect(page).to have_content("Bob Jones details")

      new_application.adults_at_address.store("456", Adult.new("Jane", "Smith", "dob", "nationality", "id_and_type"))
      new_application.save!

      visit task_list_url
      expect(page).to have_content("Bob Jones details")
      expect(page).to have_content("Jane Smith details")
    end

    it "correctly creates the resident details task item links" do
      new_application = UnaccompaniedMinor.new
      new_application.adults_at_address = {}
      new_application.adults_at_address.store("123", Adult.new("Bob", "Jones", "dob", "nationality", "id_and_type"))
      new_application.save!

      page.set_rack_session(app_reference: new_application.reference)

      visit task_list_url
      expect(page).to have_link("", href: "/sponsor-a-child/steps/29/123")
    end

    it "redirects to task list if user skips forward for other adults" do
      new_application = UnaccompaniedMinor.new
      new_application.other_adults_address = "yes"
      new_application.save!

      page.set_rack_session(app_reference: new_application.reference)

      visit "/sponsor-a-child/steps/28"
      expect(page).to have_content(task_list_content)
    end
  end

  describe "session times out after inactivity" do
    it "redirects the user to the session timed out page" do
      new_application = UnaccompaniedMinor.new
      new_application.save!

      page.set_rack_session(app_reference: new_application.reference)

      visit task_list_url
      expect(page).to have_content(task_list_content)

      click_link("Contact details")
      expect(page).to have_content("Enter your email address")

      # email address is required for the happy path
      fill_in("Email", with: "jane.doe@example.com")
      fill_in("unaccompanied_minor[email_confirm]", with: "jane.doe@example.com")

      click_button("Continue")

      fill_in("UK mobile number", with: "07777 888 999")

      # rubocop:disable RSpec/AnyInstance
      allow_any_instance_of(UnaccompaniedController).to receive(:last_seen_activity_threshold).and_return(- 10.seconds)
      # rubocop:enable RSpec/AnyInstance

      click_button("Continue")

      expect(page).to have_content("Your session has timed out due to inactivity")
    end
  end

  describe "ensure valid properties are saved and retrieved" do
    it "UK parental consent form" do
      new_application = UnaccompaniedMinor.new
      new_application.save!

      page.set_rack_session(app_reference: new_application.reference)

      visit task_list_url
      expect(page).to have_content(task_list_content)

      click_link("Upload UK consent form")
      expect(page).to have_content("You must upload 2 completed parental consent forms")

      click_button("Continue")
      expect(page).to have_content("Upload the UK sponsorship arrangement consent form")

      test_file_path = File.join(File.dirname(__FILE__), "..", "uk-test-document.pdf")

      attach_file("unaccompanied-minor-uk-parental-consent-field", test_file_path)
      click_button("Continue")

      expect(page).to have_content(task_list_content)

      saved_application = UnaccompaniedMinor.find_by_reference(new_application.reference)
      expect(saved_application.uk_parental_consent_filename).to eq("uk-test-document.pdf")
      expect(saved_application.uk_parental_consent_file_type).to eq("application/pdf")
      expect(saved_application.uk_parental_consent_saved_filename).to end_with("uk-test-document.pdf")
      expect(saved_application.uk_parental_consent_file_size).not_to be_nil
    end

    it "Ukraine parental consent form" do
      new_application = UnaccompaniedMinor.new
      new_application.save!

      page.set_rack_session(app_reference: new_application.reference)

      visit task_list_url
      expect(page).to have_content(task_list_content)

      click_link("Upload Ukrainian consent form")
      expect(page).to have_content("Upload the Ukraine certified consent form")

      test_file_path = File.join(File.dirname(__FILE__), "..", "ukraine-test-document.pdf")

      attach_file("unaccompanied-minor-ukraine-parental-consent-field", test_file_path)
      click_button("Continue")

      expect(page).to have_content(task_list_content)

      saved_application = UnaccompaniedMinor.find_by_reference(new_application.reference)
      expect(saved_application.ukraine_parental_consent_filename).to eq("ukraine-test-document.pdf")
      expect(saved_application.ukraine_parental_consent_file_type).to eq("application/pdf")
      expect(saved_application.ukraine_parental_consent_saved_filename).to end_with("ukraine-test-document.pdf")
      expect(saved_application.ukraine_parental_consent_file_size).not_to be_nil
    end

    it "have parental consent" do
      new_application = UnaccompaniedMinor.new
      new_application.save!

      page.set_rack_session(app_reference: new_application.reference)

      visit task_list_url
      expect(page).to have_content(task_list_content)

      click_link("Upload UK consent form")
      expect(page).to have_content("You must upload 2 completed parental consent forms")

      click_button("Continue")
      expect(page).to have_content("Upload the UK sponsorship arrangement consent form")

      saved_application = UnaccompaniedMinor.find_by_reference(new_application.reference)
      expect(saved_application.have_parental_consent).to eq("yes")
    end

    it "different address" do
      new_application = UnaccompaniedMinor.new
      new_application.save!

      page.set_rack_session(app_reference: new_application.reference)

      visit task_list_url
      expect(page).to have_content(task_list_content)

      click_link("Address")
      expect(page).to have_content("Enter the address where the child will be living in the UK")

      fill_in("Address line 1", with: "Address line 1")
      fill_in("Town", with: "Address town")
      fill_in("Postcode", with: "XX1 1XX")

      click_button("Continue")
      expect(page).to have_content("Will you be living at this address?")

      choose("Yes")
      click_button("Continue")

      expect(page).to have_content("Will anyone else over the age of 16 be living at this address?")

      saved_application = UnaccompaniedMinor.find_by_reference(new_application.reference)
      expect(saved_application.different_address).to eq("yes")
    end

    it "other adults at address" do
      new_application = UnaccompaniedMinor.new
      new_application.save!

      page.set_rack_session(app_reference: new_application.reference)

      visit task_list_url
      expect(page).to have_content(task_list_content)

      click_link("Address")
      expect(page).to have_content("Enter the address where the child will be living in the UK")

      fill_in("Address line 1", with: "Address line 1")
      fill_in("Town", with: "Address town")
      fill_in("Postcode", with: "XX1 1XX")

      click_button("Continue")
      expect(page).to have_content("Will you be living at this address?")

      choose("Yes")

      click_button("Continue")
      expect(page).to have_content("Will anyone else over the age of 16 be living at this address?")

      choose("No")

      click_button("Continue")
      expect(page).to have_content(task_list_content)

      saved_application = UnaccompaniedMinor.find_by_reference(new_application.reference)
      expect(saved_application.other_adults_address).to eq("no")
    end
  end

  describe "show check answers page" do
    it "when collections are empty" do
      # Create application with minimum expected values
      application = UnaccompaniedMinor.new

      application.save!

      page.set_rack_session(app_reference: application.reference)

      visit "/sponsor-a-child/check-answers"
      expect(page).to have_content("Check your answers before sending your application")
    end

    it "when other names collection is NOT empty" do
      # Create application with minimum expected values
      application = UnaccompaniedMinor.new
      application.has_other_names = "true"

      application.other_names = [["Other given name", "Other family name"]]
      application.save!

      page.set_rack_session(app_reference: application.reference)

      visit "/sponsor-a-child/check-answers"
      expect(page).to have_content("Check your answers before sending your application")
      expect(page).to have_content("Other given name Other family name")
    end

    it "when other adults collection is NOT empty" do
      # Create application with minimum expected values
      application = UnaccompaniedMinor.new

      application.adults_at_address = {}
      application.adults_at_address.store("ABC", Adult.new("Other first name", "Other family name", "dob", "nationality", "id-number"))
      application.save!

      page.set_rack_session(app_reference: application.reference)

      visit "/sponsor-a-child/check-answers"
      expect(page).to have_content("Check your answers before sending your application")
      expect(page).to have_content("Other first name Other family name")
    end

    it "when other nationalities collection is NOT empty" do
      # Create application with minimum expected values
      application = UnaccompaniedMinor.new

      application.other_nationalities = [["AFG - Afghanistan"], ["AUS - Australia"], ["CHF - Switzerland"]]
      application.save!

      page.set_rack_session(app_reference: application.reference)

      visit "/sponsor-a-child/check-answers"
      expect(page).to have_content("Check your answers before sending your application")
      expect(page).to have_content("AFG - Afghanistan")
      expect(page).to have_content("AUS - Australia")
      expect(page).to have_content("CHF - Switzerland")
    end
  end

  describe "sponsor id type and number is saved" do
    it "when id is passport" do
      application = UnaccompaniedMinor.new
      application.save!

      page.set_rack_session(app_reference: application.reference)

      visit task_list_url
      expect(page).to have_content(task_list_content)

      click_link("Additional details")
      expect(page).to have_content("Do you have any of these identity documents?")

      choose("Passport")
      click_button("Continue")

      expect(page).to have_content("You must enter a valid identity document number")

      fill_in("Passport number", with: "123456789")

      click_button("Continue")
      expect(page).to have_content("Enter your date of birth")

      saved_application = UnaccompaniedMinor.find_by_reference(application.reference)
      expect(saved_application.identification_type).to eq("passport")
      expect(saved_application.identification_number).to eq("123456789")
    end

    it "when id is national id card" do
      application = UnaccompaniedMinor.new
      application.save!

      page.set_rack_session(app_reference: application.reference)

      visit task_list_url
      expect(page).to have_content(task_list_content)

      click_link("Additional details")
      expect(page).to have_content("Do you have any of these identity documents?")

      choose("National Identity Card")
      click_button("Continue")

      expect(page).to have_content("You must enter a valid identity document number")

      fill_in("National Identity Card number", with: "ABC123456789")

      click_button("Continue")
      expect(page).to have_content("Enter your date of birth")

      saved_application = UnaccompaniedMinor.find_by_reference(application.reference)
      expect(saved_application.identification_type).to eq("national_identity_card")
      expect(saved_application.identification_number).to eq("ABC123456789")
    end

    it "when id is biometric residence" do
      application = UnaccompaniedMinor.new
      application.save!

      page.set_rack_session(app_reference: application.reference)

      visit task_list_url
      expect(page).to have_content(task_list_content)

      click_link("Additional details")
      expect(page).to have_content("Do you have any of these identity documents?")

      choose("Biometric Residence Permit or Biometric Residence Card")
      click_button("Continue")

      expect(page).to have_content("You must enter a valid identity document number")

      fill_in("Biometric Residence Permit number or Biometric Residence Card number", with: "ABC123456789")

      click_button("Continue")
      expect(page).to have_content("Enter your date of birth")

      saved_application = UnaccompaniedMinor.find_by_reference(application.reference)
      expect(saved_application.identification_type).to eq("biometric_residence")
      expect(saved_application.identification_number).to eq("ABC123456789")
    end

    it "when id is photo driving licence" do
      application = UnaccompaniedMinor.new
      application.save!

      page.set_rack_session(app_reference: application.reference)

      visit task_list_url
      expect(page).to have_content(task_list_content)

      click_link("Additional details")
      expect(page).to have_content("Do you have any of these identity documents?")

      choose("Photo driving licence")
      click_button("Continue")

      expect(page).to have_content("You must enter a valid identity document number")

      fill_in("Photo driving licence number", with: "ABC123456789")

      click_button("Continue")
      expect(page).to have_content("Enter your date of birth")

      saved_application = UnaccompaniedMinor.find_by_reference(application.reference)
      expect(saved_application.identification_type).to eq("photo_driving_licence")
      expect(saved_application.identification_number).to eq("ABC123456789")
    end


    it "when id is none" do
      application = UnaccompaniedMinor.new
      application.save!

      page.set_rack_session(app_reference: application.reference)

      visit task_list_url
      expect(page).to have_content(task_list_content)

      click_link("Additional details")
      expect(page).to have_content("Do you have any of these identity documents?")

      choose("I don't have any of these")

      click_button("Continue")
      expect(page).to have_content("Can you prove your identity?")

      saved_application = UnaccompaniedMinor.find_by_reference(application.reference)
      expect(saved_application.identification_type).to eq("none")
      expect(saved_application.identification_number).to eq("")
    end

    it "when nothing is selected an error is displayed" do
      application = UnaccompaniedMinor.new
      application.save!

      page.set_rack_session(app_reference: application.reference)

      visit task_list_url
      expect(page).to have_content(task_list_content)

      click_link("Additional details")
      expect(page).to have_content("Do you have any of these identity documents?")

      click_button("Continue")
      expect(page).to have_content("You must select an option to continue")
    end

    it "when passport number is displayed when going through id question" do
      application = UnaccompaniedMinor.new
      application.save!

      page.set_rack_session(app_reference: application.reference)

      visit task_list_url
      expect(page).to have_content(task_list_content)

      click_link("Additional details")
      expect(page).to have_content("Do you have any of these identity documents?")

      choose("Passport")
      fill_in("Passport number", with: "123987456")

      click_button("Continue")
      expect(page).to have_content("Enter your date of birth")

      visit task_list_url
      expect(page).to have_content(task_list_content)

      click_link("Additional details")
      expect(page).to have_content("Do you have any of these identity documents?")

      choose("Passport")
      expect(page).to have_field("Passport number", with: "123987456")
    end

    it "when national identity card is displayed when going through id question" do
      application = UnaccompaniedMinor.new
      application.save!

      page.set_rack_session(app_reference: application.reference)

      visit task_list_url
      expect(page).to have_content(task_list_content)

      click_link("Additional details")
      expect(page).to have_content("Do you have any of these identity documents?")

      choose("National Identity Card")
      fill_in("National Identity Card number", with: "ABC123987456")

      click_button("Continue")
      expect(page).to have_content("Enter your date of birth")

      visit task_list_url
      expect(page).to have_content(task_list_content)

      click_link("Additional details")
      expect(page).to have_content("Do you have any of these identity documents?")

      choose("National Identity Card")
      expect(page).to have_field("National Identity Card number", with: "ABC123987456")
    end

    it "when biometric residence is displayed when going through id question" do
      application = UnaccompaniedMinor.new
      application.save!

      page.set_rack_session(app_reference: application.reference)

      visit task_list_url
      expect(page).to have_content(task_list_content)

      click_link("Additional details")
      expect(page).to have_content("Do you have any of these identity documents?")

      choose("Biometric Residence Permit or Biometric Residence Card")
      fill_in("Biometric Residence Permit number or Biometric Residence Card number", with: "XYZ123987456")

      click_button("Continue")
      expect(page).to have_content("Enter your date of birth")

      visit task_list_url
      expect(page).to have_content(task_list_content)

      click_link("Additional details")
      expect(page).to have_content("Do you have any of these identity documents?")

      choose("Biometric Residence Permit or Biometric Residence Card")
      expect(page).to have_field("Biometric Residence Permit number or Biometric Residence Card number", with: "XYZ123987456")
    end

    it "when photo driving licence is displayed when going through id question" do
      application = UnaccompaniedMinor.new
      application.save!

      page.set_rack_session(app_reference: application.reference)

      visit task_list_url
      expect(page).to have_content(task_list_content)

      click_link("Additional details")
      expect(page).to have_content("Do you have any of these identity documents?")

      choose("Photo driving licence")
      fill_in("Photo driving licence number", with: "XYZ123987456")

      click_button("Continue")
      expect(page).to have_content("Enter your date of birth")

      visit task_list_url
      expect(page).to have_content(task_list_content)

      click_link("Additional details")
      expect(page).to have_content("Do you have any of these identity documents?")

      choose("Photo driving licence")
      expect(page).to have_field("Photo driving licence number", with: "XYZ123987456")
    end
  end
end
