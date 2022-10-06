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
    let(:task_list_content) { "Apply for approval to provide a safe home for a child from Ukraine".freeze }
    let(:other_nationality_content) { "Enter your other nationality".freeze }

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

    it "when a nationality is added, it's removed from the list" do
      task_list_to_other_nationalities_question
      add_one_nationality

      click_button("Continue")

      expect(page).not_to have_content("Albania")
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

    describe "UAM other nationailties select other nationality form" do
      it "does not allow for empty other nationality to be selected " do
        task_list_to_other_nationalities_question

        choose("Yes")
        click_button("Continue")

        click_button("Continue")

        expect(page).to have_content("Error: You must select a valid nationality")
      end

      it "shows an error box when no nationality is selected " do
        task_list_to_other_nationalities_question

        choose("Yes")
        click_button("Continue")

        click_button("Continue")

        expect(page).to have_content("There is a problem")
      end
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

      expect(page).to have_content(other_nationality_content)

      select("Albania", from: "unaccompanied-minor-other-nationality-field")
      click_button("Continue")

      expect(page).to have_content("You have added 1 other nationalit")
      expect(page).to have_content("ALB - Albania")
      expect(page).to have_link("Remove", href: expected_first_remove_url)

      click_link("Add another nationality")

      expect(page).to have_content(other_nationality_content)

      select("Algeria", from: "unaccompanied-minor-other-nationality-field")
      click_button("Continue")

      expect(page).to have_content("You have added 2 other nationalit")
      expect(page).to have_content(expected_algeria_added_copy)
      expect(page).to have_link("Remove", href: expected_second_remove_url)
    end

    def add_one_nationality
      choose("Yes")
      click_button("Continue")

      expect(page).to have_content(other_nationality_content)

      select("Albania", from: "unaccompanied-minor-other-nationality-field")
      click_button("Continue")

      expect(page).to have_content("You have added 1 other nationalit")
      expect(page).to have_content("ALB - Albania")
      expect(page).to have_link("Remove", href: expected_first_remove_url)

      click_link("Add another nationality")

      expect(page).to have_content(other_nationality_content)
    end
  end
end
