RSpec.describe "Unaccompanied minor other adults", type: :system do
    let(:completed_task_list_content) { "You have completed 4 of 4 sections." }
    let(:minors_dob_year) { (Time.zone.now - 4.years).year }
    let(:sponsor_dob_year) { (Time.zone.now - 20.years).year }
    let(:app_reference) {"BIG-REFERENCE"}
    let(:task_list_path) { "/sponsor-a-child/task-list" }
    let(:task_list_content) { "Apply for approval to provide a safe home for a child from Ukraine" }
    let(:minors_email) { "unaccompanied.minor@test.com" }
    let(:minors_phone) { "07983111111" }
    let(:minors_dob) { Time.zone.now - 4.years }
      
    before do
        driven_by(:rack_test_user_agent)
        new_application = UnaccompaniedMinor.new
        new_application.save!
    
        page.set_rack_session(app_reference: new_application.reference)
    end

    fdescribe "user completes their application" do 
        it "shows reference number on confirm page" do 
            visit "/sponsor-a-child/task-list"
            expect(page).to have_content(task_list_content)

            click_link("Name")

            expect(page).to have_content("Enter your name")
            fill_in("Given names", with: "Tim")
            fill_in("Family name", with: "Marsh")
            click_button("Continue")

            expect(page).to have_content("Have you ever been known by another name?")
            choose("No")
            click_button("Continue")

            expect(page).to have_content(task_list_content)
            expect(page).to have_content("You have completed 0 of 4 sections.")

            click_link("Contact details")

            expect(page).to have_content("Enter your email address")
            fill_in("Email", with: "Tim@mail.com")
            click_button("Continue")

            expect(page).to have_content("Enter your UK phone number")
            fill_in("Phone_number", with: "07123123123")
            click_button("Continue")

            expect(page).to have_content(task_list_content)
            expect(page).to have_content("You have completed 0 of 4 sections.")
            
            click_link("Additional details")

            expect(page).to have_content("Do you have any of these identity documents?")
            choose("Passport")
            fill_in("Passport number", with: "123123123")
            click_button("Continue")

            expect(page).to have_content("Enter your date of birth")
            fill_in("Day", with: "1")
            fill_in("Month", with: "1")
            fill_in("Year", with: "#{(Time.zone.now - 20.year).year}")
            click_button("Continue")

            expect(page).to have_content("Enter your nationality")
            select("Denmark", from: "unaccompanied-minor-nationality-field")
            click_button("Continue")

            expect(page).to have_content("Have you ever held any other nationalities?")
            choose("No")
            click_button("Continue")

            expect(page).to have_content(task_list_content)
            expect(page).to have_content("You have completed 1 of 4 sections.")

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
            expect(page).to have_content("You have completed 2 of 4 sections.")

            click_link("Child's personal details")

            expect(page).to have_content("Enter the name of the child you want to sponsor")
            fill_in("Given names", with: "Minor")
            fill_in("Family name", with: "Child")
            click_button("Continue")

            expect(page).to have_content("How can we contact the child?")
            expect(page).to have_content("Minor Child")
            check("Email")
            fill_in("Email", with: "child@email.com")
            click_button("Continue")
            
            expect(page).to have_content("Enter their date of birth")

           
        end
    end
end 