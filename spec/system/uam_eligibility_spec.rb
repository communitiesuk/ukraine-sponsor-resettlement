require "rails_helper"

RSpec.describe "Unaccompanied minor expression of interest", type: :system do
  before do
    driven_by(:rack_test_user_agent)
  end

  let(:start_page_content) { "Apply to provide a safe home for a child from Ukraine" }

  describe "User checks their eligibility" do
    it "shows the guidance page before the start page" do
      visit "/sponsor-a-child/"
      expect(page).to have_content(start_page_content)

      click_link(start_page_content)

      expect(page).to have_content(start_page_content)
    end

    it "shows check if eligible for this service page" do
      visit "/sponsor-a-child/start"
      expect(page).to have_content(start_page_content)

      click_link("Start now")

      expect(page).to have_content("Check if you are eligible to use this service")
    end

    it "takes the user to the end of eligibility path" do
      uam_enter_valid_complete_eligibility_section
    end

    it "shows the user uneligible page if they answer NO to any question" do
      visit "/sponsor-a-child/start"
      expect(page).to have_content(start_page_content)

      click_link("Start now")
      expect(page).to have_content("Check if you are eligible to use this service")

      click_link("Continue")

      expect(page).to have_content("Is the child you want to sponsor under 18?")
      uam_choose_option("No")

      expect(page).to have_content("You cannot use this service")
    end

    it "shows eligibility question 3 if 2 is answered NO" do
      visit "/sponsor-a-child/start"
      expect(page).to have_content(start_page_content)

      click_link("Start now")

      expect(page).to have_content("Check if you are eligible to use this service")

      click_link("Continue")

      expect(page).to have_content("Is the child you want to sponsor under 18?")
      uam_choose_option("Yes")

      expect(page).to have_content("Was the child living in Ukraine on or before 31 December 2021?")
      uam_choose_option("No")

      expect(page).to have_content("Was the child born after 31 December 2021?")
    end

    it "shows ineligibility if 6 is answered NO" do
      visit "/sponsor-a-child/start"
      expect(page).to have_content(start_page_content)

      click_link("Start now")

      expect(page).to have_content("Check if you are eligible to use this service")

      click_link("Continue")

      expect(page).to have_content("Is the child you want to sponsor under 18?")
      uam_choose_option("Yes")

      expect(page).to have_content("Was the child living in Ukraine on or before 31 December 2021?")
      uam_choose_option("Yes")

      expect(page).to have_content("Are they travelling to the UK with a parent or legal guardian?")
      uam_choose_option("No")

      expect(page).to have_content("Can you upload both consent forms?")
      uam_choose_option("Yes")

      expect(page).to have_content("Can you commit to hosting the child for the minimum period?")
      uam_choose_option("No")


      expect(page).to have_content("You cannot use this service")
    end
  end
end
