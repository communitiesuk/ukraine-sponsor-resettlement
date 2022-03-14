require "rails_helper"

RSpec.describe "Individual expression of interest", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe "submitting the form" do
    it "saves all of the answers in the database" do
      visit root_path
      expect(page).to have_content("Homes for Ukraine")
      click_link("Register your interest as an individual")

      expect(page).to have_content("Who would you like to sponsor?")
      choose("Friend or Colleague")
      click_button("Continue")

      expect(page).to have_content("Are you willing to sponsor a family or a single person?")
      choose("Single person")
      click_button("Continue")

      expect(page).to have_content("What type of living space can you offer?")
      choose("Rooms in your home")
      click_button("Continue")

      expect(page).to have_content("Is the entire property accessible to people with mobility impairments?")
      choose("Yes")
      click_button("Continue")

      fill_in("How many single rooms do you have available?", with: 3)
      click_button("Continue")

      fill_in("How many double rooms do you have available?", with: 2)
      click_button("Continue")

      fill_in("Enter the postcode of the main property you’re offering.", with: "SG13 7DF")
      click_button("Continue")

      expect(page).to have_content("How long can you offer accommodation?")
      choose("3 to 6 months")
      click_button("Continue")

      expect(page).to have_content("Do you have a current Disclosure and Barring Service (DBS) certificate?")
      choose("Yes")
      click_button("Continue")

      expect(page).to have_content("Are you willing to answer more questions to confirm your suitability as a sponsor?")
      choose("Yes")
      click_button("Continue")

      fill_in("Enter your full name", with: "John Smith")
      click_button("Continue")

      fill_in("Enter your email address", with: "john.smith@example.com")
      click_button("Continue")

      fill_in("Enter your mobile number", with: "0123456789")
      click_button("Continue")

      expect(page).to have_content("Sponsor type Friend or Colleague")
      expect(page).to have_content("Family or individual Single")
      expect(page).to have_content("Living space type Rooms In Home")
      expect(page).to have_content("Mobility impaired accessible property Yes")
      expect(page).to have_content("Single rooms available 3")
      expect(page).to have_content("Double rooms available 2")
      expect(page).to have_content("Property postcode SG13 7DF")
      expect(page).to have_content("Accomodation length 3 to 6 months")
      expect(page).to have_content("Disclosure and Barring Service certificate Yes")
      expect(page).to have_content("Willing to answer more questions Yes")
      expect(page).to have_content("Name John Smith")
      expect(page).to have_content("Email john.smith@example.com")
      expect(page).to have_content("Mobile number 0123456789")
      click_button("Accept And Send")

      expect(page).to have_content("Application complete")

      application = IndividualExpressionOfInterest.order("created_at DESC").last
      expect(application.as_json).to include({
        sponsor_type: "friend_or_colleague",
        family_or_single_type: "single",
        living_space_type: "rooms_in_home",
        mobility_impairments_type: "yes",
        single_room_count: "3",
        double_room_count: "2",
        postcode: "SG13 7DF",
        accommodation_length_type: "less_than_6_months",
        dbs_certificate_type: "yes",
        answer_more_questions_type: "yes",
        fullname: "John Smith",
        email: "john.smith@example.com",
        mobile_number: "0123456789",
      })
    end
  end
end
