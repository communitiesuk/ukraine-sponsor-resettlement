require "rails_helper"

RSpec.describe "Expression of interest", type: :system do
  before do
    driven_by(:rack_test_user_agent)
  end

  describe "Validation" do
    it "wont let you continue on an empty name field" do
      eoi_skip_to_questions
      click_on("Continue")

      expect(page).to have_content("Error: You must enter your full name")
    end

    it "won't let you enter just one name" do
      eoi_skip_to_questions
      fill_in("Enter your full name", with: "Tim")
      click_on("Continue")

      expect(page).to have_content("Error: You must enter your full name")
    end

    it "won't let you continue on an empty email field" do
      eoi_skip_to_questions
      eoi_enter_sponsor_name
      click_on("Continue")

      expect(page).to have_content("Error: You must enter a valid email address")
    end

    it "stops progression on an invalid email address" do
      eoi_skip_to_questions
      eoi_enter_sponsor_name
      fill_in("Enter your email address", with: "Notanemail.com")
      click_on("Continue")

      expect(page).to have_content("Error: You must enter a valid email address")
    end

    it "validates empty field for phone number" do
      eoi_skip_to_questions
      eoi_enter_sponsor_name
      fill_in("Enter your email address", with: "test@test.com")
      click_on("Continue")
      click_on("Continue")

      expect(page).to have_content("Enter a telephone number, like 01632 960 001 or +44 808 157 0192")
      expect(page).to have_content("Error: Enter a telephone number in the correct format")
    end

    it "won't allow you to continue on an invalid phone number" do
      eoi_skip_to_questions
      eoi_enter_sponsor_name
      fill_in("Enter your email address", with: "test@test.com")
      click_on("Continue")
      fill_in("Enter a telephone number, like 01632 960 001 or +44 808 157 0192", with: "00123")
      click_on("Continue")

      expect(page).to have_content("Enter a telephone number, like 01632 960 001 or +44 808 157 0192")
      expect(page).to have_content("Error: Enter a telephone number in the correct format")
    end

    it "won't allow you to continue if the first line of the address isn't present" do
      eoi_skip_to_questions
      eoi_enter_sponsor_name
      eoi_enter_sponsor_contact_details
      eoi_enter_address(line1: "", town: "HouseTown", postcode: "CH1 1LD")

      expect(page).to have_content("Error: You must enter an address")
    end

    it "won't allow you to continue if the address town or city isn't present" do
      eoi_skip_to_questions
      eoi_enter_sponsor_name
      eoi_enter_sponsor_contact_details
      eoi_enter_address(line1: "HouseTown", town: "", postcode: "CH1 1LD")

      expect(page).to have_content("Error: You must enter a town or city")
    end

    it "won't allow you to continue if the address postcode isn't present" do
      eoi_skip_to_questions
      eoi_enter_sponsor_name
      eoi_enter_sponsor_contact_details
      eoi_enter_address(line1: "HouseTown", town: "CHILD", postcode: "")

      expect(page).to have_content("Error: You must enter a valid UK postcode")
    end

    it "won't allow no choice on different address question" do
      eoi_skip_to_questions
      eoi_enter_sponsor_name
      eoi_enter_sponsor_contact_details
      eoi_enter_address
      click_on("Continue")

      expect(page).to have_content("Error: You must select an option to continue")
    end

    it "won't allow no first line on different address question" do
      eoi_skip_to_questions
      eoi_enter_sponsor_name
      eoi_enter_sponsor_contact_details
      eoi_enter_address
      eoi_choose_option("Yes")
      eoi_enter_address(line1: "", town: "DifferentTown", postcode: "XX1 1LD")

      expect(page).to have_content("Error: You must enter an address")
    end

    it "won't allow no town on different address question" do
      eoi_skip_to_questions
      eoi_enter_sponsor_name
      eoi_enter_sponsor_contact_details
      eoi_enter_address
      eoi_choose_option("Yes")
      eoi_enter_address(line1: "Street1", town: "", postcode: "XX1 1LD")

      expect(page).to have_content("Error: You must enter a town or city")
    end

    it "won't allow no postcode on different address question" do
      eoi_skip_to_questions
      eoi_enter_sponsor_name
      eoi_enter_sponsor_contact_details
      eoi_enter_address
      eoi_choose_option("Yes")
      eoi_enter_address(line1: "Street1", town: "DifferentTown", postcode: "")

      expect(page).to have_content("Error: You must enter a valid UK postcode")
    end

    it "won't allow no choice on more properties question" do
      eoi_skip_to_questions
      eoi_enter_sponsor_name
      eoi_enter_sponsor_contact_details
      eoi_enter_address
      eoi_choose_option("Yes")
      eoi_enter_address(line1: "Street1", town: "DifferentTown", postcode: "TE3 3ST")
      click_on("Continue")

      expect(page).to have_content("Error: You must select an option to continue")
    end

    it "won't allow no choice on how soon question" do
      eoi_skip_to_questions
      eoi_enter_sponsor_name
      eoi_enter_sponsor_contact_details
      eoi_enter_address
      eoi_choose_option("Yes")
      eoi_enter_address(line1: "Street1", town: "DifferentTown", postcode: "TE3 3ST")
      eoi_choose_option("Yes")
      click_on("Continue")
      click_on("Continue")

      expect(page).to have_content("Error: You must select an option to continue")
      expect(page).to have_no_content("Error: Enter a valid start date")
    end

    it "validates no entry for hosting start date" do
      eoi_skip_to_questions
      eoi_enter_sponsor_name
      eoi_enter_sponsor_contact_details
      eoi_enter_address
      eoi_choose_option("Yes")
      eoi_enter_address(line1: "Street1", town: "DifferentTown", postcode: "TE3 3ST")
      eoi_choose_option("Yes")
      click_on("Continue")
      choose("From a specific date")
      click_on("Continue")

      expect(page).to have_content("Error: Enter a valid start date")
    end

    it "wont allow hosting start date to be in the past" do
      eoi_skip_to_questions
      eoi_enter_sponsor_name
      eoi_enter_sponsor_contact_details
      eoi_enter_address
      eoi_choose_option("Yes")
      eoi_enter_address(line1: "Street1", town: "DifferentTown", postcode: "TE3 3ST")
      eoi_choose_option("Yes")
      click_on("Continue")
      choose("From a specific date")

      eoi_fill_in_date_of_birth(Time.zone.now.utc - 1.year)

      expect(page).to have_content("Error: Enter a valid start date")
    end

    it "wont allow blank adult field" do
      eoi_skip_to_questions
      eoi_enter_sponsor_name
      eoi_enter_sponsor_contact_details
      eoi_enter_address
      eoi_choose_option("Yes")
      eoi_enter_address(line1: "Street1", town: "DifferentTown", postcode: "TE3 3ST")
      eoi_choose_option("Yes")
      click_on("Continue")
      choose("From a specific date")
      eoi_fill_in_date_of_birth(Time.zone.now.utc + 1.year)
      fill_in("Children", with: "2")
      click_on("Continue")

      expect(page).to have_content("Error: You must enter a number from 0-9")
    end

    it "wont allow blank child field" do
      eoi_skip_to_questions
      eoi_enter_sponsor_name
      eoi_enter_sponsor_contact_details
      eoi_enter_address
      eoi_choose_option("Yes")
      eoi_enter_address(line1: "Street1", town: "DifferentTown", postcode: "TE3 3ST")
      eoi_choose_option("Yes")
      click_on("Continue")
      choose("From a specific date")
      eoi_fill_in_date_of_birth(Time.zone.now.utc + 1.year)
      fill_in("Adult", with: "2")
      click_on("Continue")

      expect(page).to have_content("Error: You must enter a number from 0-9")
    end

    it "wont allow children without adult" do
      eoi_skip_to_questions
      eoi_enter_sponsor_name
      eoi_enter_sponsor_contact_details
      eoi_enter_address
      eoi_choose_option("Yes")
      eoi_enter_address(line1: "Street1", town: "DifferentTown", postcode: "TE3 3ST")
      eoi_choose_option("Yes")
      click_on("Continue")
      choose("From a specific date")
      eoi_fill_in_date_of_birth(Time.zone.now.utc + 1.year)
      fill_in("Adult", with: "0")
      fill_in("Children", with: "3")
      click_on("Continue")

      expect(page).to have_content("Error: There must be at least 1 adult living with children")
    end

    it "wont allow no choice on refugee preference" do
      eoi_skip_to_questions
      eoi_enter_sponsor_name
      eoi_enter_sponsor_contact_details
      eoi_enter_address
      eoi_choose_option("Yes")
      eoi_enter_address(line1: "Street1", town: "DifferentTown", postcode: "TE3 3ST")
      eoi_choose_option("Yes")
      click_on("Continue")
      choose("From a specific date")
      eoi_fill_in_date_of_birth(Time.zone.now.utc + 1.year)
      eoi_people_at_address
      click_on("Continue")

      expect(page).to have_content("Error: You must select an option to continue")
    end

    it "wont allow no entry on bedroom questions" do
      eoi_skip_to_questions
      eoi_enter_sponsor_name
      eoi_enter_sponsor_contact_details
      eoi_enter_address
      eoi_choose_option("Yes")
      eoi_enter_address(line1: "Street1", town: "DifferentTown", postcode: "TE3 3ST")
      eoi_choose_option("Yes")
      click_on("Continue")
      choose("From a specific date")
      eoi_fill_in_date_of_birth(Time.zone.now.utc + 1.year)
      eoi_people_at_address
      eoi_sponsor_refugee_preference
      click_on("Continue")

      expect(page).to have_content("Error: You must enter a number from 0 to 9")
    end

    it "wont allow both zeros on bedroom questions" do
      eoi_skip_to_questions
      eoi_enter_sponsor_name
      eoi_enter_sponsor_contact_details
      eoi_enter_address
      eoi_choose_option("Yes")
      eoi_enter_address(line1: "Street1", town: "DifferentTown", postcode: "TE3 3ST")
      eoi_choose_option("Yes")
      click_on("Continue")
      choose("From a specific date")
      eoi_fill_in_date_of_birth(Time.zone.now.utc + 1.year)
      eoi_people_at_address
      eoi_sponsor_refugee_preference
      fill_in("expression-of-interest-single-room-count-field", with: 0)
      fill_in("expression-of-interest-double-room-count-field", with: 0)
      click_on("Continue")

      expect(page).to have_content("You must enter a number from 1 to 9 in either field")
    end

    it "wont allow no choice on step free question" do
      eoi_skip_to_questions
      eoi_enter_sponsor_name
      eoi_enter_sponsor_contact_details
      eoi_enter_address
      eoi_choose_option("Yes")
      eoi_enter_address(line1: "Street1", town: "DifferentTown", postcode: "TE3 3ST")
      eoi_choose_option("Yes")
      click_on("Continue")
      choose("From a specific date")
      eoi_fill_in_date_of_birth(Time.zone.now.utc + 1.year)
      eoi_people_at_address
      eoi_sponsor_refugee_preference
      eoi_number_of_rooms
      click_on("Continue")

      expect(page).to have_content("You must select an option to continue")
    end

    it "wont allow no choice on pets question" do
      eoi_skip_to_questions
      eoi_enter_sponsor_name
      eoi_enter_sponsor_contact_details
      eoi_enter_address
      eoi_choose_option("Yes")
      eoi_enter_address(line1: "Street1", town: "DifferentTown", postcode: "TE3 3ST")
      eoi_choose_option("Yes")
      click_on("Continue")
      choose("From a specific date")
      eoi_fill_in_date_of_birth(Time.zone.now.utc + 1.year)
      eoi_people_at_address
      eoi_sponsor_refugee_preference
      eoi_number_of_rooms
      choose("Yes, all")
      click_on("Continue")
      click_on("Continue")

      expect(page).to have_content("You must select an option to continue")
    end

    it "wont allow no choice on research question" do
      eoi_skip_to_questions
      eoi_enter_sponsor_name
      eoi_enter_sponsor_contact_details
      eoi_enter_address
      eoi_choose_option("Yes")
      eoi_enter_address(line1: "Street1", town: "DifferentTown", postcode: "TE3 3ST")
      eoi_choose_option("Yes")
      click_on("Continue")
      choose("From a specific date")
      eoi_fill_in_date_of_birth(Time.zone.now.utc + 1.year)
      eoi_people_at_address
      eoi_sponsor_refugee_preference
      eoi_number_of_rooms
      eoi_accessibility_info
      click_on("Continue")

      expect(page).to have_content("You must select an option to continue")
    end

    it "wont allow no choice on privacy statement question" do
      eoi_skip_to_questions
      eoi_enter_sponsor_name
      eoi_enter_sponsor_contact_details
      eoi_enter_address
      eoi_choose_option("Yes")
      eoi_enter_address(line1: "Street1", town: "DifferentTown", postcode: "TE3 3ST")
      eoi_choose_option("Yes")
      click_on("Continue")
      choose("From a specific date")
      eoi_fill_in_date_of_birth(Time.zone.now.utc + 1.year)
      eoi_people_at_address
      eoi_sponsor_refugee_preference
      eoi_number_of_rooms
      eoi_accessibility_info
      eoi_choose_option("Yes")
      click_on("Continue")

      expect(page).to have_content("You must tick the box to continue")
    end
  end
end
