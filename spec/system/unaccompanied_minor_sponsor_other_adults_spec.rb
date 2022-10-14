require "rails_helper"
require "securerandom"

RSpec.describe "Unaccompanied minor sponsor other adults", type: :system do
  before do
    driven_by(:rack_test_user_agent)
  end

  describe "other adults identification documents" do
    let(:task_list_content) { "Apply for approval to provide a safe home for a child from Ukraine".freeze }
    let(:invalid_id_number) { "You must enter a valid identity document number" }
    let(:invalid_id_entries) { ["", " ", "-", "*test", "12345", "AbCdE"].freeze }
    let(:valid_document_id) { "SomeValidId123456".freeze }

    before do
      application = UnaccompaniedMinor.new
      application.adults_at_address = {}
      application.adults_at_address.store("123", Adult.new("Bob", "Jones", "2001-6-13", "Afghanistan", "id_and_type"))
      application.save!

      page.set_rack_session(app_reference: application.reference)
    end

    it " shows an error when the id type is not answered" do
      navigate_to_id_document_entry

      click_button("Continue")

      expect(page).to have_content("You must select an option to continue")
    end

    it "shows an error when the passport entry is not valid" do
      navigate_to_id_document_entry

      invalid_id_entries.each do |line|
        choose("Passport")
        fill_in("Passport number", with: line)
        click_button("Continue")

        expect(page).to have_content(invalid_id_number), "Failed value:#{line.inspect}"
      end
    end

    it "goes to task list when the passport entry is valid" do
      navigate_to_id_document_entry

      choose("Passport")
      fill_in("Passport number", with: valid_document_id)
      click_button("Continue")

      expect(page).to have_content(task_list_content)
    end

    it " shows an error when the national id card entry is not valid" do
      navigate_to_id_document_entry

      invalid_id_entries.each do |line|
        choose("National identity card")
        fill_in("National identity card", with: line)
        click_button("Continue")

        expect(page).to have_content(invalid_id_number), "Failed value:#{line.inspect}"
      end
    end

    it "goes to task list when the national id card entry is valid" do
      navigate_to_id_document_entry

      choose("National identity card")
      fill_in("National identity card", with: valid_document_id)
      click_button("Continue")

      expect(page).to have_content(task_list_content)
    end

    it "shows an error when the Refugee travel document entry is not valid" do
      navigate_to_id_document_entry

      invalid_id_entries.each do |line|
        choose("Refugee travel document")
        fill_in("National identity card", with: line)
        click_button("Continue")

        expect(page).to have_content(invalid_id_number), "Failed value:#{line.inspect}"
      end
    end

    it "goes to task list when the Refugee travel document entry is valid" do
      navigate_to_id_document_entry

      choose("Refugee travel document")
      fill_in("Refugee travel document", with: valid_document_id)
      click_button("Continue")

      expect(page).to have_content(task_list_content)
    end

    it "returns to the task list when 'I don't have any of these' is selected" do
      navigate_to_id_document_entry

      choose("I don't have any of these")
      click_button("Continue")

      expect(page).to have_content(task_list_content)
    end

    def navigate_to_id_document_entry
      visit "/sponsor-a-child/task-list"
      expect(page).to have_content("Bob Jones details")

      click_link("Bob Jones details")
      expect(page).to have_content("Enter this person's date of birth")

      expect(page).to have_field("Day", with: 13)
      expect(page).to have_field("Month", with: 6)
      expect(page).to have_field("Year", with: 2001)

      click_button("Continue")

      expect(page).to have_content("Enter their nationality")
      select("Denmark", from: "unaccompanied-minor-adult-nationality-field")
      click_button("Continue")

      expect(page).to have_content("Do they have any of these identity documents?")
    end
  end
end
