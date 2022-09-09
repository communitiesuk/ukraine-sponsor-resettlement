RSpec.describe "Unaccompanied minor other adults", type: :system do
  let(:completed_task_list_content) { "You have completed 4 of 4 sections." }
  let(:minors_dob) { Time.zone.now - 4.years }
  let(:sponsor_dob) { Time.zone.now - 20.years }
  let(:task_list_path) { "/sponsor-a-child/task-list" }
  let(:task_list_content) { "Apply for approval to provide a safe home for a child from Ukraine" }

  describe "user completes their application" do
    before do
      driven_by(:rack_test_user_agent)

      new_application = UnaccompaniedMinor.new
      new_application.save!

      page.set_rack_session(app_reference: new_application.reference)
    end

    it "shows reference number on confirm page" do
      visit "/sponsor-a-child/start"

      expect(page).to have_content("Apply to provide a safe home for a child from Ukraine")
      click_link("Start now")

      visit "/sponsor-a-child/steps/1"

      expect(page).to have_content("Is the child you want to sponsor under 18?")
      choose_option_and_continue("Yes")

      expect(page).to have_content("Was the child living in Ukraine on or before 31 December 2021?")
      choose_option_and_continue("Yes")

      expect(page).to have_content("Are they travelling to the UK with a parent or legal guardian?")
      choose_option_and_continue("No")

      expect(page).to have_content("Can you upload both consent forms?")
      choose_option_and_continue("Yes")

      expect(page).to have_content("Can you commit to hosting the child for the minimum period?")
      choose_option_and_continue("Yes")

      expect(page).to have_content("Do you have permission to live in the UK for the minimum period?")
      choose_option_and_continue("Yes")

      expect(page).to have_content("You are eligible to use this service")
      click_link("Start application")

      expect(page).to have_content(task_list_content)

      click_link("Name")

      expect(page).to have_content("Enter your name")
      fill_in_name_and_continue("Tim", "Marsh")

      expect(page).to have_content("Have you ever been known by another name?")
      choose_option_and_continue("No")

      expect(page).to have_content(task_list_content)
      check_sections_complete(0)

      click_link("Contact details")

      expect(page).to have_content("Enter your email address")
      fill_in("Email", with: "Tim@mail.com")
      fill_in("unaccompanied-minor-email-confirm-field", with: "Tim@mail.com")
      click_button("Continue")

      expect(page).to have_content("Enter your UK phone number")
      fill_in("Phone_number", with: "07123123123")
      click_button("Continue")

      expect(page).to have_content(task_list_content)
      check_sections_complete(0)

      click_link("Additional details")

      expect(page).to have_content("Do you have any of these identity documents?")
      choose("Passport")
      fill_in("Passport number", with: "123123123")
      click_button("Continue")

      expect(page).to have_content("Enter your date of birth")
      fill_in_dob_and_continue(sponsor_dob)

      expect(page).to have_content("Enter your nationality")
      select("Denmark", from: "unaccompanied-minor-nationality-field")
      click_button("Continue")

      expect(page).to have_content("Have you ever held any other nationalities?")
      choose_option_and_continue("No")

      expect(page).to have_content(task_list_content)
      check_sections_complete(1)

      click_link("Address")

      expect(page).to have_content("Enter the address where the child will be living in the UK")
      fill_in("Address line 1", with: "Address line 1")
      fill_in("Town", with: "Address town")
      fill_in("Postcode", with: "XX1 1XX")
      click_button("Continue")

      expect(page).to have_content("Will you be living at this address?")
      choose_option_and_continue("Yes")

      expect(page).to have_content("Will anyone else over the age of 16 be living at this address?")
      choose_option_and_continue("No")

      expect(page).to have_content(task_list_content)
      check_sections_complete(2)

      click_link("Child's personal details")

      expect(page).to have_content("Enter the name of the child you want to sponsor")
      fill_in_name_and_continue("Minor", "Child")

      expect(page).to have_content("How can we contact the child?")
      check("Email")
      fill_in("Email", with: "child@email.com")
      fill_in("Confirm Email", with: "child@email.com")
      click_button("Continue")

      expect(page).to have_content("Enter their date of birth")
      fill_in_dob_and_continue(minors_dob)

      expect(page).to have_content(task_list_content)
      check_sections_complete(2)

      click_link("Upload UK consent form")
      expect(page).to have_content("You must upload 2 completed parental consent forms")
      click_button("Continue")

      expect(page).to have_content("Upload the UK sponsorship arrangement consent form")
      test_file_path = File.join(File.dirname(__FILE__), "..", "uk-test-document.pdf")
      attach_file("unaccompanied-minor-uk-parental-consent-field", test_file_path)
      click_button("Continue")

      click_link("Upload Ukrainian consent form")

      expect(page).to have_content("Upload the Ukraine certified consent form")
      test_file_path = File.join(File.dirname(__FILE__), "..", "ukraine-test-document.pdf")
      attach_file("unaccompanied-minor-ukraine-parental-consent-field", test_file_path)
      click_button("Continue")

      expect(page).to have_content(task_list_content)
      check_sections_complete(3)

      click_link("Confirm we can use your data")

      expect(page).to have_content("Confirm you have read the privacy statement and all people involved agree that the information you have provided can be used for the Homes for Ukraine scheme")
      check("unaccompanied_minor[privacy_statement_confirm]")
      click_button("Continue")

      expect(page).to have_content(task_list_content)

      click_link("Confirm your eligibility")
      expect(page).to have_content("Confirm your eligibility to sponsor a child from Ukraine")
      check("unaccompanied_minor[sponsor_declaration]")
      click_button("Continue")

      expect(page).to have_content(task_list_content)
      check_sections_complete(4)

      click_link("Check your answers and send")
      expect(page).to have_content("Check your answers before sending your application")
      find("button[type=submit]").click

      expect(page).to have_content("SPON-")
      visit "/sponsor-a-child/confirm"
      expect(page).to have_content("SPON-")

      page.set_rack_session(app_reference: nil)
      visit "/sponsor-a-child/confirm"
      expect(page).to have_content("Use this service to apply for approval to sponsor a child fleeing Ukraine, who is not travelling with or joining their parent or legal guardian in the UK.")
    end

    def choose_option_and_continue(choice)
      choose(choice)
      click_button("Continue")
    end

    def fill_in_name_and_continue(given, family)
      fill_in("Given names", with: given)
      fill_in("Family name", with: family)
      click_button("Continue")
    end

    def fill_in_dob_and_continue(date)
      fill_in("Day", with: date.day)
      fill_in("Month", with: date.month)
      fill_in("Year", with: date.year)
      click_button("Continue")
    end

    def check_sections_complete(complete_sections)
      expect(page).to have_content("You have completed #{complete_sections} of 4 sections.")
    end
  end
end
