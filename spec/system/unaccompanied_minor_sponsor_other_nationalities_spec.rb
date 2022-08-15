require "rails_helper"
require "securerandom"

RSpec.describe "Unaccompanied minor sponsor other nationalities", type: :system do
  before do
    driven_by(:rack_test_user_agent)
  end

  describe "sponsor enters other nationalities" do
    let(:expected_algeria_added_copy) { "DZA - Algeria".freeze }
    let(:expected_second_remove_url) { "/sponsor-a-child/remove-other-nationality/DZA".freeze }
    let(:expected_first_remove_url) { "/sponsor-a-child/remove-other-nationality/ALB".freeze }
    let(:main_nationality) { "Afghanistan".freeze }
    let(:task_list_content) { "Apply for permission to sponsor a child fleeing Ukraine without a parent".freeze }

    before do
      application = UnaccompaniedMinor.new
      application.save!

      page.set_rack_session(app_reference: application.reference)
    end

    it "when asked for extra nationalities - shows an error when yes or no is not selected" do
      task_list_to_other_nationalities_question
      click_button("Continue")

      expect(page).to have_content("You must select an option")
    end

    it "when no other nationalities are added go to task list" do
      task_list_to_other_nationalities_question

      choose("No")
      click_button("Continue")
      expect(page).to have_content(task_list_content)
    end

    it "when other nationalities are added and not removed clicking continue returns to task list" do
      task_list_to_other_nationalities_question
      add_two_extra_nationalities

      click_link("Continue")
      expect(page).to have_content(task_list_content)
    end

    it "when other nationalities are added and all removed, return to the task list" do
      task_list_to_other_nationalities_question
      add_two_extra_nationalities

      click_link(href: expected_second_remove_url)
      expect(page).to have_content("You have added 1 other nationalit")
      expect(page).not_to have_content(expected_algeria_added_copy)

      click_link(href: expected_first_remove_url)

      expect(page).to have_content(task_list_content)
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

    def add_two_extra_nationalities
      choose("Yes")
      click_button("Continue")

      expect(page).to have_content("What is your other nationality?")

      select("Albania", from: "unaccompanied-minor-other-nationality-field")
      click_button("Continue")

      expect(page).to have_content("You have added 1 other nationalit")
      expect(page).to have_content("ALB - Albania")
      expect(page).to have_link("Remove", href: expected_first_remove_url)

      click_link("Add another nationality")

      expect(page).to have_content("What is your other nationality?")

      select("Algeria", from: "unaccompanied-minor-other-nationality-field")
      click_button("Continue")

      expect(page).to have_content("You have added 2 other nationalit")
      expect(page).to have_content(expected_algeria_added_copy)
      expect(page).to have_link("Remove", href: expected_second_remove_url)
    end
  end
end
