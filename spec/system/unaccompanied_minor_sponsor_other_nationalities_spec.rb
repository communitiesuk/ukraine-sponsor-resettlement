require "rails_helper"
require "securerandom"

RSpec.describe "Unaccompanied minor sponsor other nationalities", type: :system do
  before do
    driven_by(:rack_test_user_agent)
  end

  describe "sponsor enters other names" do
    let(:task_list_content) { "Apply for permission to sponsor a child fleeing Ukraine without a parent".freeze }
    let(:main_nationality) { "Afghanistan".freeze }

    before do
      application = UnaccompaniedMinor.new
      application.save!

      page.set_rack_session(app_reference: application.reference)
    end

    def task_list_to_other_nationalities_question
      visit "/sponsor-a-child/task-list"
      expect(page).to have_content(task_list_content)

      click_link("Additional details")
      expect(page).to have_content("Do you have any of these identity documents?")

      choose(option: "passport")
      fill_in("Passport number", with: "123456789")
      click_button("Continue")

      expect(page).to have_content("Enter your date of birth")

      fill_in("Day", with: "1")
      fill_in("Month", with: "1")
      fill_in("Year", with: "2000")
      click_button("Continue")

      expect(page).to have_content("Enter your nationality")

      select(main_nationality, from: "unaccompanied-minor-nationality-field")
      click_button("Continue")

      expect(page).to have_content("Have you ever held any other nationalities?")
    end

    it "when no other nationalities are added go to task list" do
      task_list_to_other_nationalities_question

      choose("No")
      click_button("Continue")
      expect(page).to have_content(task_list_content)
    end

    it "when other nationalities are added" do
      task_list_to_other_nationalities_question

      choose("Yes")
      click_button("Continue")

      expect(page).to have_content("What is your other nationality?")

      select("Albania", from: "unaccompanied-minor-other-nationality-field")
      click_button("Continue")

      expect(page).to have_content("You have added 1 other nationalities")
      expect(page).to have_content("ALB - Albania")

      expected_first_remove_url = "/sponsor-a-child/remove-other-nationality/ALB".freeze
      expect(page).to have_link("Remove", href: expected_first_remove_url)

      click_link("Add another nationality")

      expect(page).to have_content("What is your other nationality?")

      select("Algeria", from: "unaccompanied-minor-other-nationality-field")
      click_button("Continue")

      expect(page).to have_content("You have added 2 other nationalities")
      expect(page).to have_content("DZA - Algeria")

      expected_second_remove_url = "/sponsor-a-child/remove-other-nationality/DZA".freeze
      expect(page).to have_link("Remove", href: expected_second_remove_url)

      click_link("Continue")
      expect(page).to have_content(task_list_content)
    end
  end
end
