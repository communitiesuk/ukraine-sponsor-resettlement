require "rails_helper"
require "securerandom"

RSpec.describe "Unaccompanied minor sponsor other adults", type: :system do
  before do
    driven_by(:rack_test_user_agent)
  end

  describe "other adults identification documents" do
    let(:task_list_content) { "Apply for permission to sponsor a child fleeing Ukraine without a parent".freeze }

    before do
      application = UnaccompaniedMinor.new
      application.save!

      page.set_rack_session(app_reference: application.reference)
    end

    it "when no document option is selected shows an error" do
      task_list_to_identity_documents_question
      click_button("Continue")

      expect(page).to have_content("Select an identity document you have, or select ‘I don't have any of these’")
    end

    def task_list_to_identity_documents_question
      visit "/sponsor-a-child/task-list"
      expect(page).to have_content(task_list_content)

      click_link("Address")

      fill_in("Address line 1", with: "Property 1 House number and Street name")
      fill_in("Town", with: "Property 1 Some Town or City")
      fill_in("Postcode", with: "AA1 1AA")
      click_button("Continue")

      expect(page).to have_content("Will you (the sponsor) be living at this address?")
      choose("Yes")
      click_button("Continue")

      expect(page).to have_content("Will anyone else over the age of 16 be living at this address?")
      choose("Yes")
      click_button("Continue")

      expect(page).to have_content("Enter the name of the person over 16 who will live with the child")

      fill_in("Given name(s)", with: "Other")
      fill_in("Family name", with: "Resident")
      click_button("Continue")

      expect(page).to have_content("You have added 1 person over 16 who will live with the child")
      click_link("Continue")

      expect(page).to have_content(task_list_content)

      click_link("Other Resident details")

      expect(page).to have_content("Enter this person's date of birth")

      fill_in("Day", with: "1")
      fill_in("Month", with: "1")
      fill_in("Year", with: "2000")
      click_button("Continue")

      expect(page).to have_content("Enter their nationality")

      # let(:main_nationality) { "Afghanistan".freeze }
      select("Afghanistan", from: "unaccompanied-minor-adult-nationality-field")
      click_button("Continue")

      expect(page).to have_content("Do they have any of these identity documents?")
    end
  end
end
