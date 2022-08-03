require "rails_helper"
require "securerandom"

RSpec.describe "Unaccompanied minor expression of interest", type: :system do
  before do
    driven_by(:rack_test_user_agent)
  end

  describe "start page" do
    it "sponsor url shows page" do
      visit "/sponsor-a-child"
      expect(page).to have_content("Apply to provide a safe home for a child from Ukraine")
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
      expect(page).to have_content("Apply to provide a safe home for a child from Ukraine")

      click_link("Apply for permission to sponsor an unaccompanied child fleeing Ukraine")

      expect(page).to have_content("Apply to provide a safe home for a child from Ukraine")
    end

    it "shows check if eligible for this service page" do
      visit "/sponsor-a-child/start"
      expect(page).to have_content("Apply to provide a safe home for a child from Ukraine")

      click_link("Start now")

      expect(page).to have_content("Check if you are eligible to use this service")
    end

    it "shows the user uneligible page if they answer NO to any question" do
      visit "/sponsor-a-child/start"
      expect(page).to have_content("Apply to provide a safe home for a child from Ukraine")

      click_link("Start now")
      expect(page).to have_content("Check if you are eligible to use this service")

      click_link("Continue")

      # step 1
      expect(page).to have_content("Is the child you want to sponsor under 18?")
      choose("No")
      click_button("Continue")

      expect(page).to have_content("You cannot use this service")
    end

    it "takes the user to the end of eligibility path" do
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

      # step 9
      expect(page).to have_content("You are eligible to use this service")
    end

    it "shows eligibility question 3 if 2 is answered NO" do
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
      choose("No")
      click_button("Continue")

      # step 3
      expect(page).to have_content("Was the child born after 31 December 2021?")
    end

    it "shows ineligibility if 6 is answered NO" do
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
      choose("No")
      click_button("Continue")

      # ineligible
      expect(page).to have_content("You cannot use this service")
    end

    it "end to end eligibility journey" do
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

      fill_in("Email", with: "jane.doe@test.com")
      click_button("Continue")

      fill_in("Phone_number", with: "07777 888 999")
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

      choose("Passport")
      fill_in("Passport number", with: "123456789")
      click_button("Continue")

      fill_in("Day", with: "6")
      fill_in("Month", with: "11")
      fill_in("Year", with: "1987")
      click_button("Continue")

      expect(page).to have_content("Enter your nationality")
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
      expect(page).to have_content("Jane Doe")
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

      click_button("Continue")
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
      fill_in("Email", with: "jane.doe@example.com")
      click_button("Continue")
      fill_in("Phone_number", with: "07777 888 999")

      # rubocop:disable RSpec/AnyInstance
      allow_any_instance_of(UnaccompaniedController).to receive(:last_seen_activity_threshold).and_return(- 10.seconds)
      # rubocop:enable RSpec/AnyInstance

      click_button("Continue")

      expect(page).to have_content("Your session has timed out due to inactivity")
    end
  end

  describe "complete over 16 year old flow" do
    it "answer the date of birth question" do
      new_application = UnaccompaniedMinor.new
      new_application.adults_at_address = {}
      new_application.adults_at_address.store("123", Adult.new("Bob", "Jones"))
      new_application.save!

      page.set_rack_session(app_reference: new_application.reference)

      visit "/sponsor-a-child/task-list"
      expect(page).to have_content("Bob Jones details")

      click_link("Bob Jones details")
      expect(page).to have_content("Enter this person's date of birth")

      fill_in("Day", with: 1)
      fill_in("Month", with: 2)
      fill_in("Year", with: Time.zone.now.year - 12)

      click_button("Continue")
      expect(page).to have_content("Enter this person's date of birth")
      expect(page).to have_content("They must be over 16")

      fill_in("Day", with: 1)
      fill_in("Month", with: 2)
      fill_in("Year", with: Time.zone.now.year - 20)

      click_button("Continue")
      expect(page).to have_content("Enter their nationality")
    end
  end

  it "answer the nationality question" do
    new_application = UnaccompaniedMinor.new
    new_application.adults_at_address = {}
    new_application.adults_at_address.store("123", Adult.new("Bob", "Jones", "2001-6-13"))
    new_application.save!

    page.set_rack_session(app_reference: new_application.reference)

    visit "/sponsor-a-child/task-list"
    expect(page).to have_content("Bob Jones details")

    click_link("Bob Jones details")
    expect(page).to have_content("Enter this person's date of birth")

    expect(page).to have_field("Day", with: 13)
    expect(page).to have_field("Month", with: 6)
    expect(page).to have_field("Year", with: 2001)

    click_button("Continue")
    expect(page).to have_content("Enter their nationality")

    select("Denmark", from: "unaccompanied-minor-adult-nationality-field")

    click_button("Continue")
    expect(page).to have_content("Do they have any of these identity documents?")
  end

  it "answer the id type and number question" do
    new_application = UnaccompaniedMinor.new
    new_application.adults_at_address = {}
    new_application.adults_at_address.store("123", Adult.new("Bob", "Jones", "2001-6-13", "Afghanistan"))
    new_application.save!

    page.set_rack_session(app_reference: new_application.reference)

    visit "/sponsor-a-child/task-list"
    expect(page).to have_content("Bob Jones details")

    click_link("Bob Jones details")
    expect(page).to have_content("Enter this person's date of birth")

    expect(page).to have_field("Day", with: 13)
    expect(page).to have_field("Month", with: 6)
    expect(page).to have_field("Year", with: 2001)

    click_button("Continue")
    expect(page).to have_content("Enter their nationality")

    click_button("Continue")
    expect(page).to have_content("Do they have any of these identity documents?")

    click_button("Continue")
    expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")
  end

  describe "ensure valid properties are saved and retrieved" do
    it "UK parental consent form" do
      new_application = UnaccompaniedMinor.new
      new_application.save!

      page.set_rack_session(app_reference: new_application.reference)

      visit "/sponsor-a-child/task-list"
      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")

      click_link("Upload parental consent (British)")
      expect(page).to have_content("You must upload 2 completed parental consent forms")

      click_button("Continue")
      expect(page).to have_content("Upload the UK sponsorship arrangement consent form")

      test_file_path = File.join(File.dirname(__FILE__), "..", "uk-test-document.pdf")

      attach_file("unaccompanied-minor-uk-parental-consent-field", test_file_path)
      click_button("Continue")

      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")

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

      visit "/sponsor-a-child/task-list"
      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")

      click_link("Upload parental consent (Ukraine)")
      expect(page).to have_content("Upload the Ukraine notarised consent form")

      test_file_path = File.join(File.dirname(__FILE__), "..", "ukraine-test-document.pdf")

      attach_file("unaccompanied-minor-ukraine-parental-consent-field", test_file_path)
      click_button("Continue")

      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")

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

      visit "/sponsor-a-child/task-list"
      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")

      click_link("Upload parental consent (British)")
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

      saved_application = UnaccompaniedMinor.find_by_reference(new_application.reference)
      expect(saved_application.different_address).to eq("yes")
    end

    it "other adults at address" do
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

      saved_application = UnaccompaniedMinor.find_by_reference(new_application.reference)
      expect(saved_application.other_adults_address).to eq("no")
    end
  end

  describe "show check answers page" do
    it "when collections are empty" do
      # Create application with minimum expected values
      application = UnaccompaniedMinor.new
      application.has_other_names = "false"
      application.minor_contact_type = "email"
      application.save!

      page.set_rack_session(app_reference: application.reference)

      visit "/sponsor-a-child/check-answers"
      expect(page).to have_content("Check your answers before sending your application")
    end

    it "when other names collection is NOT empty" do
      # Create application with minimum expected values
      application = UnaccompaniedMinor.new
      application.has_other_names = "true"
      application.minor_contact_type = "email"
      application.other_names = ["Other given name", "Other family name"]
      application.save!

      page.set_rack_session(app_reference: application.reference)

      visit "/sponsor-a-child/check-answers"
      expect(page).to have_content("Check your answers before sending your application")
      expect(page).to have_content("Other given name Other family name")
    end

    it "when other adults collection is NOT empty" do
      # Create application with minimum expected values
      application = UnaccompaniedMinor.new
      application.has_other_names = "false"
      application.minor_contact_type = "email"
      application.adults_at_address = {}
      application.adults_at_address.store("ABC", Adult.new("Other first name", "Other family name"))
      application.save!

      page.set_rack_session(app_reference: application.reference)

      visit "/sponsor-a-child/check-answers"
      expect(page).to have_content("Check your answers before sending your application")
      expect(page).to have_content("Other first name Other family name")
    end

    it "when other nationalities collection is NOT empty" do
      # Create application with minimum expected values
      application = UnaccompaniedMinor.new
      application.has_other_names = "false"
      application.minor_contact_type = "email"
      application.other_nationalities = ["AFG - Afghanistan", "AUS - Australia", "CHF - Switzerland"]
      application.save!

      page.set_rack_session(app_reference: application.reference)

      visit "/sponsor-a-child/check-answers"
      expect(page).to have_content("Check your answers before sending your application")
      expect(page).to have_content("AFG - Afghanistan")
      expect(page).to have_content("AUS - Australia")
      expect(page).to have_content("CHF - Switzerland")
    end

    it "when minor cannot be contacted" do
      application = UnaccompaniedMinor.new
      application.has_other_names = "false"
      application.save!

      page.set_rack_session(app_reference: application.reference)

      visit "/sponsor-a-child/check-answers"
      expect(page).to have_content("Check your answers before sending your application")
      expect(page).to have_content("They cannot be contacted")
    end

    it "when minor can be contacted by email" do
      email_address = "minor@example.com"

      application = UnaccompaniedMinor.new
      application.has_other_names = "false"
      application.minor_contact_type = "email"
      application.minor_email = email_address
      application.save!

      page.set_rack_session(app_reference: application.reference)

      visit "/sponsor-a-child/check-answers"
      expect(page).to have_content("Check your answers before sending your application")
      expect(page).to have_content(email_address)
    end

    it "when minor can be contacted by telephone" do
      telephone_number = "0777123456"

      application = UnaccompaniedMinor.new
      application.has_other_names = "false"
      application.minor_contact_type = "telephone"
      application.minor_phone_number = telephone_number
      application.save!

      page.set_rack_session(app_reference: application.reference)

      visit "/sponsor-a-child/check-answers"
      expect(page).to have_content("Check your answers before sending your application")
      expect(page).to have_content(telephone_number)
    end
  end

  describe "sponsor id type and number is saved" do
    it "when id is passport" do
      application = UnaccompaniedMinor.new
      application.save!

      page.set_rack_session(app_reference: application.reference)

      visit "/sponsor-a-child/task-list"
      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")

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

      visit "/sponsor-a-child/task-list"
      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")

      click_link("Additional details")
      expect(page).to have_content("Do you have any of these identity documents?")

      choose("National Identity card")
      click_button("Continue")

      expect(page).to have_content("You must enter a valid identity document number")

      fill_in("National Identity card number", with: "ABC123456789")

      click_button("Continue")
      expect(page).to have_content("Enter your date of birth")

      saved_application = UnaccompaniedMinor.find_by_reference(application.reference)
      expect(saved_application.identification_type).to eq("national_identity_card")
      expect(saved_application.identification_number).to eq("ABC123456789")
    end

    it "when id is refugee travel document" do
      application = UnaccompaniedMinor.new
      application.save!

      page.set_rack_session(app_reference: application.reference)

      visit "/sponsor-a-child/task-list"
      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")

      click_link("Additional details")
      expect(page).to have_content("Do you have any of these identity documents?")

      choose("Refugee travel document")
      click_button("Continue")

      expect(page).to have_content("You must enter a valid identity document number")

      fill_in("Refugee travel document number", with: "ABC123456789")

      click_button("Continue")
      expect(page).to have_content("Enter your date of birth")

      saved_application = UnaccompaniedMinor.find_by_reference(application.reference)
      expect(saved_application.identification_type).to eq("refugee_travel_document")
      expect(saved_application.identification_number).to eq("ABC123456789")
    end

    it "when id is none" do
      application = UnaccompaniedMinor.new
      application.save!

      page.set_rack_session(app_reference: application.reference)

      visit "/sponsor-a-child/task-list"
      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")

      click_link("Additional details")
      expect(page).to have_content("Do you have any of these identity documents?")

      choose("I don't have any of these")

      click_button("Continue")
      expect(page).to have_content("What can you use to prove your identity?")

      saved_application = UnaccompaniedMinor.find_by_reference(application.reference)
      expect(saved_application.identification_type).to eq("none")
      expect(saved_application.identification_number).to eq("")
    end

    it "when nothing is selected an error is displayed" do
      application = UnaccompaniedMinor.new
      application.save!

      page.set_rack_session(app_reference: application.reference)

      visit "/sponsor-a-child/task-list"
      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")

      click_link("Additional details")
      expect(page).to have_content("Do you have any of these identity documents?")

      click_button("Continue")
      expect(page).to have_content("Select an identity document you have, or select ‘I don't have any of these’")
    end

    it "when passport number is displayed when going through id question" do
      application = UnaccompaniedMinor.new
      application.save!

      page.set_rack_session(app_reference: application.reference)

      visit "/sponsor-a-child/task-list"
      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")

      click_link("Additional details")
      expect(page).to have_content("Do you have any of these identity documents?")

      choose("Passport")
      fill_in("Passport number", with: "123987456")

      click_button("Continue")
      expect(page).to have_content("Enter your date of birth")

      visit "/sponsor-a-child/task-list"
      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")

      click_link("Additional details")
      expect(page).to have_content("Do you have any of these identity documents?")

      choose("Passport")
      expect(page).to have_field("Passport number", with: "123987456")
    end

    it "when National Identity card is displayed when going through id question" do
      application = UnaccompaniedMinor.new
      application.save!

      page.set_rack_session(app_reference: application.reference)

      visit "/sponsor-a-child/task-list"
      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")

      click_link("Additional details")
      expect(page).to have_content("Do you have any of these identity documents?")

      choose("National Identity card")
      fill_in("National Identity card number", with: "ABC123987456")

      click_button("Continue")
      expect(page).to have_content("Enter your date of birth")

      visit "/sponsor-a-child/task-list"
      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")

      click_link("Additional details")
      expect(page).to have_content("Do you have any of these identity documents?")

      choose("National Identity card")
      expect(page).to have_field("National Identity card number", with: "ABC123987456")
    end

    it "when Refugee travel document is displayed when going through id question" do
      application = UnaccompaniedMinor.new
      application.save!

      page.set_rack_session(app_reference: application.reference)

      visit "/sponsor-a-child/task-list"
      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")

      click_link("Additional details")
      expect(page).to have_content("Do you have any of these identity documents?")

      choose("Refugee travel document")
      fill_in("Refugee travel document number", with: "XYZ123987456")

      click_button("Continue")
      expect(page).to have_content("Enter your date of birth")

      visit "/sponsor-a-child/task-list"
      expect(page).to have_content("Apply for permission to sponsor a child fleeing Ukraine without a parent")

      click_link("Additional details")
      expect(page).to have_content("Do you have any of these identity documents?")

      choose("Refugee travel document")
      expect(page).to have_field("Refugee travel document number", with: "XYZ123987456")
    end
  end

  describe "sponsor enters other names" do
    task_list_content = "Apply for permission to sponsor a child fleeing Ukraine without a parent".freeze

    before do
      application = UnaccompaniedMinor.new
      application.save!

      page.set_rack_session(app_reference: application.reference)

      visit "/sponsor-a-child/start-application"
      expect(page).to have_content(task_list_content)

      click_link("Name")
      fill_in("Given name(s)", with: "Given")
      fill_in("Family name", with: "Family")
      click_button("Continue")
      expect(page).to have_content("Have you ever been known by another name?")
    end

    it "when no other names are added go to task list" do
      choose("No")
      click_button("Continue")

      expect(page).to have_content(task_list_content)
    end

    it "when other names are entered" do
      first_other_given_name = "Firstextra".freeze
      first_other_family_name = "Firstfamily".freeze
      second_other_given_name = "Secondextra".freeze
      second_other_family_name = "Secondfamily".freeze

      choose("Yes")
      click_button("Continue")

      expect(page).to have_content("What is your other name?")

      fill_in("Given name(s)", with: first_other_given_name)
      fill_in("Family name", with: first_other_family_name)
      click_button("Continue")

      expect(page).to have_content("You have added 1 other names")
      expect(page).to have_content(first_other_given_name)
      expect(page).to have_content(first_other_family_name)

      expected_first_remove_url = "/sponsor-a-child/remove-other-name/#{first_other_given_name}/#{first_other_family_name}".freeze
      expect(page).to have_link("Remove", href: expected_first_remove_url)

      click_link("Add another name")
      expect(page).to have_content("What is your other name?")
      fill_in("Given name(s)", with: second_other_given_name)
      fill_in("Family name", with: second_other_family_name)
      click_button("Continue")

      expect(page).to have_content("You have added 2 other names")
      expect(page).to have_content(second_other_given_name)
      expect(page).to have_content(second_other_family_name)

      expected_second_remove_url = "/sponsor-a-child/remove-other-name/#{second_other_given_name}/#{second_other_family_name}".freeze
      expect(page).to have_link("Remove", href: expected_second_remove_url)

      click_link("Continue")
      expect(page).to have_content(task_list_content)
    end

    it "when other names are entered and all removed" do
      first_other_given_name = "Firstextra".freeze
      first_other_family_name = "Firstfamily".freeze
      second_other_given_name = "Secondextra".freeze
      second_other_family_name = "Secondfamily".freeze

      choose("Yes")
      click_button("Continue")

      expect(page).to have_content("What is your other name?")

      fill_in("Given name(s)", with: first_other_given_name)
      fill_in("Family name", with: first_other_family_name)
      click_button("Continue")

      expect(page).to have_content("You have added 1 other names")
      expect(page).to have_content(first_other_given_name)
      expect(page).to have_content(first_other_family_name)

      expected_first_remove_url = "/sponsor-a-child/remove-other-name/#{first_other_given_name}/#{first_other_family_name}".freeze
      expect(page).to have_link("Remove", href: expected_first_remove_url)

      click_link("Add another name")
      expect(page).to have_content("What is your other name?")
      fill_in("Given name(s)", with: second_other_given_name)
      fill_in("Family name", with: second_other_family_name)
      click_button("Continue")

      expect(page).to have_content("You have added 2 other names")
      expect(page).to have_content(second_other_given_name)
      expect(page).to have_content(second_other_family_name)

      expected_second_remove_url = "/sponsor-a-child/remove-other-name/#{second_other_given_name}/#{second_other_family_name}".freeze
      expect(page).to have_link("Remove", href: expected_second_remove_url)

      click_link(href: expected_second_remove_url)
      expect(page).to have_content("You have added 1 other names")
      expect(page).not_to have_content(second_other_given_name)
      expect(page).not_to have_content(second_other_family_name)

      click_link(href: expected_first_remove_url)
      expect(page).to have_content(task_list_content)

    end
  end
end
