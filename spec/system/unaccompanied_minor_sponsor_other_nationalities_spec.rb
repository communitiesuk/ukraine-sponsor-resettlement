require "rails_helper"
require "securerandom"

RSpec.describe "Unaccompanied minor sponsor other nationalities", type: :system do
  before do
    driven_by(:rack_test_user_agent)
  end

  describe "sponsor enters other names" do
    let(:task_list_content) { "Apply for permission to sponsor a child fleeing Ukraine without a parent".freeze }
    let(:first_nationality) { "Firstextra".freeze }

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

      select("Afghanistan", from: "unaccompanied-minor-nationality-field")
      click_button("Continue")

      expect(page).to have_content("Have you ever held any other nationalities?")
    end

    it "when no other nationalities are added go to task list" do
      task_list_to_other_nationalities_question

      choose("No")
      click_button("Continue")
      expect(page).to have_content(task_list_content)
    end

    # it "when other nationalities are added" do
    #  #task list
    #  # click additional details
    #  # docs - passport + "123456789" => continue
    #  # date of birth 2000-1-1 => continue
    #  # Nationality Afgan - contiue
    #  # Others - yes, continue
    #  # Add one
    #  # Should show with a remove link
    # end

    # it "when other names are entered and all removed" do
    # end
  end
end
