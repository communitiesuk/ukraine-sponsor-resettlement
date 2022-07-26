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
      new_application = UnaccompaniedMinor.new
      new_application.save!

      expect(new_application.is_cancelled).to be(false)

      page.set_rack_session(app_reference: new_application.reference)

      visit "/sponsor-a-child/task-list"
      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")

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

      visit "/sponsor-a-child/task-list"
      expect(page).to have_content("Your application has been cancelled")
    end

    it "render confirmation on task list if already submitted" do
      new_application = UnaccompaniedMinor.new
      new_application.transferred_at = Time.zone.now
      new_application.save!

      expect(new_application.transferred_at).not_to be_nil

      page.set_rack_session(app_reference: new_application.reference)

      visit "/sponsor-a-child/task-list"
      expect(page).to have_content("Application complete")
    end

    it "redirect to task list if user decides to continue application" do
      new_application = UnaccompaniedMinor.new
      new_application.save!

      expect(new_application.is_cancelled).to be(false)

      page.set_rack_session(app_reference: new_application.reference)

      visit "/sponsor-a-child/task-list"
      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")

      click_button("Cancel application")
      expect(page).to have_content("Are you sure you want to cancel your application?")

      click_button("Continue application")
      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")

      continued_application = UnaccompaniedMinor.find_by_reference(new_application.reference)
      expect(continued_application.is_cancelled).to eq(false)
    end
  end

  describe "submitting the form" do
    it "shows the guidance page before the start page" do
      visit "/sponsor-a-child/"
      expect(page).to have_content("Sponsor a child fleeing Ukraine without a parent")

      click_link("Apply for permission to sponsor an unaccompanied child fleeing Ukraine")

      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")
    end

    it "shows check if eligible for this service page" do
      visit "/sponsor-a-child/start"
      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")

      click_link("Start now")

      expect(page).to have_content("Check if you can use this service")
    end

    it "shows the user uneligible page if they answer NO to any question" do
      visit "/sponsor-a-child/start"
      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")

      click_link("Start now")
      expect(page).to have_content("Check if you can use this service")

      click_link("Continue")

      # step 1
      expect(page).to have_content("Is the child you want to sponsor under 18?")
      choose("No")
      click_button("Continue")

      expect(page).to have_content("You cannot use this service")
    end

    it "takes the user to the end of eligibility path" do
      visit "/sponsor-a-child/start"
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

      # step 9
      expect(page).to have_content("You are eligible to use this service")
    end

    it "shows eligibility question 3 if 2 is answered NO" do
      visit "/sponsor-a-child/start"
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
      choose("No")
      click_button("Continue")

      # step 3
      expect(page).to have_content("Was the child born after 31 December 2021?")
    end

    it "shows ineligibility if 6 is answered NO" do
      visit "/sponsor-a-child/start"
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
      choose("No")
      click_button("Continue")

      # step 5
      expect(page).to have_content("Can you upload both consent forms?")
      choose("Yes")
      click_button("Continue")

      # step 6
      expect(page).to have_content("Can you commit to hosting the child for the minimum period?")
      choose("No")
      click_button("Continue")

      # ineligible
      expect(page).to have_content("You cannot use this service")
    end

    it "end to end eligibility journey" do
      visit "/sponsor-a-child/start"
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
    end

    it "complete child flow name(s) section and save answers to the db" do
      new_application = UnaccompaniedMinor.new
      new_application.save!

      page.set_rack_session(app_reference: new_application.reference)

      visit "/sponsor-a-child/task-list"
      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")

      click_link("Name")
      expect(page).to have_content("What is your name?")

      fill_in("Given name(s)", with: "Jane")
      fill_in("Family name", with: "Doe")

      click_button("Continue")
      expect(page).to have_content("Have you ever been known by another name?")

      choose("No")
      click_button("Continue")

      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")
    end

    it "complete child flow contact details section and save answers to the db" do
      new_application = UnaccompaniedMinor.new
      new_application.save!

      page.set_rack_session(app_reference: new_application.reference)

      visit "/sponsor-a-child/task-list"
      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")

      click_link("Contact details")
      expect(page).to have_content("What is your email address?")

      fill_in("What is your email address?", with: "jane.doe@test.com")
      click_button("Continue")

      fill_in("What is your UK telephone number?", with: "07777 888 999")
      click_button("Continue")

      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")
    end

    it "complete child flow additional details section and save answers to the db" do
      new_application = UnaccompaniedMinor.new
      new_application.save!

      page.set_rack_session(app_reference: new_application.reference)

      visit "/sponsor-a-child/task-list"
      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")

      click_link("Additional details")
      expect(page).to have_content("Do you have any of these identity documents?")

      page.check("unaccompanied-minor-identification-type-passport-field")
      click_button("Continue")

      fill_in("Day", with: "6")
      fill_in("Month", with: "11")
      fill_in("Year", with: "1987")
      click_button("Continue")

      expect(page).to have_content("What is your nationality?")
      click_button("Continue")

      expect(page).to have_content("Have you ever held any other nationalities?")
      choose("No")
      click_button("Continue")

      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")
    end
  end

  describe "submitting the form for child's flow" do
    it "saves all the data to the database" do
      new_application = UnaccompaniedMinor.new
      new_application.save!
      minor_dob_under_18_year = Time.zone.now.year - 4

      page.set_rack_session(app_reference: new_application.reference)

      visit "/sponsor-a-child/task-list"
      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")

      click_link("Child's personal details")
      expect(page).to have_content("Enter the name of the child you want to sponsor")

      fill_in("Given name(s)", with: "Jane")
      fill_in("Family name", with: "Doe")

      click_button("Continue")
      expect(page).to have_content("How can we contact")

      check("Email")
      fill_in("Email", with: "unaccompanied.minor@test.com")

      click_button("Continue")
      expect(page).to have_content("Enter their date of birth")

      fill_in("Day", with: 3)
      fill_in("Month", with: 6)
      fill_in("Year", with: minor_dob_under_18_year)

      click_button("Continue")
      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")
    end

    it "saves all the UK parent consent form to the database" do
      new_application = UnaccompaniedMinor.new
      new_application.save!

      page.set_rack_session(app_reference: new_application.reference)

      visit "/sponsor-a-child/task-list"
      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")

      click_link("Upload parental consent (British)")
      expect(page).to have_content("You must upload 2 completed parental consent forms")

      click_link("Continue")
      expect(page).to have_content("Upload the UK sponsorship arrangement consent form")

      test_file_path = File.join(File.dirname(__FILE__), "..", "uk-test-document.pdf")

      attach_file("unaccompanied-minor-uk-parental-consent-field", test_file_path)
      click_button("Continue")

      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")
    end

    it "saves all the Ukraine parent consent form to the database" do
      new_application = UnaccompaniedMinor.new
      new_application.save!

      page.set_rack_session(app_reference: new_application.reference)

      visit "/sponsor-a-child/task-list"
      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")

      click_link("Upload parental consent (Ukraine)")
      expect(page).to have_content("Upload the Ukraine notarised consent form")

      test_file_path = File.join(File.dirname(__FILE__), "..", "ukraine-test-document.pdf")

      attach_file("unaccompanied-minor-ukraine-parental-consent-field", test_file_path)
      click_button("Continue")

      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")
    end
  end

  describe "submitting the address for child" do
    it "submit the form when address is where the child is staying with the sponsor" do
      new_application = UnaccompaniedMinor.new
      new_application.save!

      page.set_rack_session(app_reference: new_application.reference)

      visit "/sponsor-a-child/task-list"
      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")

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

      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")
    end

    it "submit the form when address is where the child is NOT staying with the sponsor" do
      new_application = UnaccompaniedMinor.new
      new_application.save!

      page.set_rack_session(app_reference: new_application.reference)

      visit "/sponsor-a-child/task-list"
      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")

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
      expect(page).to have_content("Enter the name of the person over 16 who will live with the child")

      fill_in("Given name(s)", with: "Another")
      fill_in("Family name", with: "Adult")

      click_button("Continue")
      expect(page).to have_content("You have added 1 person over 16 who will live with the child")
      expect(page).to have_content("Another Adult")
    end

    it "when multiple over 16 year olds are staying at the address" do
      new_application = UnaccompaniedMinor.new
      new_application.save!

      page.set_rack_session(app_reference: new_application.reference)

      visit "/sponsor-a-child/task-list"
      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")

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
      expect(page).to have_content("Enter the name of the person over 16 who will live with the child")

      fill_in("Given name(s)", with: "First")
      fill_in("Family name", with: "Adult")

      click_button("Continue")
      expect(page).to have_content("You have added 1 person over 16 who will live with the child")
      expect(page).to have_content("First Adult")

      click_link("Add another person")
      expect(page).to have_content("Enter the name of the person over 16 who will live with the child")

      fill_in("Given name(s)", with: "Second")
      fill_in("Family name", with: "Adult")

      click_button("Continue")
      expect(page).to have_content("You have added 2 people over 16 who will live with the child")
      expect(page).to have_content("Second Adult")
    end

    it "when single over 16 year olds are staying at the address and is removed" do
      new_application = UnaccompaniedMinor.new
      new_application.save!

      page.set_rack_session(app_reference: new_application.reference)

      visit "/sponsor-a-child/task-list"
      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")

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
      expect(page).to have_content("Enter the name of the person over 16 who will live with the child")

      fill_in("Given name(s)", with: "First")
      fill_in("Family name", with: "Adult")

      click_button("Continue")
      expect(page).to have_content("You have added 1 person over 16 who will live with the child")
      expect(page).to have_content("First Adult")

      click_link("Remove")
      expect(page).to have_content("Enter the name of the person over 16 who will live with the child")
    end
  end

  describe "Goes through child flow and enters DoB" do
    it "enters blank DoB" do
      new_application = UnaccompaniedMinor.new
      new_application.save!

      page.set_rack_session(app_reference: new_application.reference)

      visit "/sponsor-a-child/task-list"
      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")

      click_link("Child's personal details")
      expect(page).to have_content("Enter the name of the child you want to sponsor")

      fill_in("Given name(s)", with: "Jane")
      fill_in("Family name", with: "Doe")

      click_button("Continue")
      expect(page).to have_content("How can we contact")

      check("Email")
      fill_in("Email", with: "unaccompanied.minor@test.com")

      click_button("Continue")
      expect(page).to have_content("date of birth")

      click_button("Continue")
      expect(page).to have_content("Enter a valid date of birth")
    end
  end

  describe "task list dynamic elements" do
    it "correctly numbers the headings" do
      new_application = UnaccompaniedMinor.new
      new_application.save!

      page.set_rack_session(app_reference: new_application.reference)

      visit "/sponsor-a-child/task-list"
      expect(page).not_to have_content("3. Residents' details")
      expect(page).to have_content("3. Tell us about the child")
      expect(page).to have_content("4. Send your application")

      new_application.adults_at_address = {}
      new_application.adults_at_address.store("123", Adult.new("Bob", "Jones"))
      new_application.save!

      visit "/sponsor-a-child/task-list"
      expect(page).to have_content("3. Residents' details")
      expect(page).to have_content("4. Tell us about the child")
      expect(page).to have_content("5. Send your application")
    end

    it "correctly shows the resident details task items" do
      new_application = UnaccompaniedMinor.new
      new_application.adults_at_address = {}
      new_application.adults_at_address.store("123", Adult.new("Bob", "Jones"))
      new_application.save!

      page.set_rack_session(app_reference: new_application.reference)

      visit "/sponsor-a-child/task-list"
      expect(page).to have_content("Bob Jones details")

      new_application.adults_at_address.store("456", Adult.new("Jane", "Smith"))
      new_application.save!

      visit "/sponsor-a-child/task-list"
      expect(page).to have_content("Bob Jones details")
      expect(page).to have_content("Jane Smith details")
    end

    it "correctly creates the resident details task item links" do
      new_application = UnaccompaniedMinor.new
      new_application.adults_at_address = {}
      new_application.adults_at_address.store("123", Adult.new("Bob", "Jones"))
      new_application.save!

      page.set_rack_session(app_reference: new_application.reference)

      visit "/sponsor-a-child/task-list"
      expect(page).to have_link("", href: "/sponsor-a-child/steps/29/123")
    end
  end

  describe "session times out after inactivity" do
    it "redirects the user to the session timed out page" do
      new_application = UnaccompaniedMinor.new
      new_application.save!

      page.set_rack_session(app_reference: new_application.reference)

      visit "/sponsor-a-child/task-list"
      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")

      click_link("Contact details")
      expect(page).to have_content("What is your email address?")

      # email address is required for the happy path
      fill_in("What is your email address?", with: "jane.doe@example.com")
      click_button("Continue")
      fill_in("What is your UK telephone number?", with: "07777 888 999")

      # rubocop:disable RSpec/AnyInstance
      allow_any_instance_of(UnaccompaniedController).to receive(:last_seen_activity_threshold).and_return(- 10.seconds)
      # rubocop:enable RSpec/AnyInstance

      click_button("Continue")

      # Back to home page for now
      expect(page).to have_content("You cannot use this service")
    end
  end
end
