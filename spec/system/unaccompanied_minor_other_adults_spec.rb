RSpec.describe "Unaccompanied minor other adults", type: :system do
  before do
    driven_by(:rack_test_user_agent)

    new_application = UnaccompaniedMinor.new
    new_application.adults_at_address = {}
    new_application.adults_at_address.store("123", Adult.new("Bob", "Jones"))
    new_application.save!

    page.set_rack_session(app_reference: new_application.reference)
  end

  describe "complete over 16 year old flow" do
    let(:task_list_content) { "Apply for permission to sponsor a child fleeing Ukraine without a parent".freeze }

    it "prompts for DoB, nationality and id documents and returns to task list" do
      add_date_of_birth
      enter_valid_nationality
      enter_valid_passport

      expect(page).to have_content(task_list_content)
    end

    it "prompts for valid entries for DoB, nationality and document" do
      too_young = "They must be over 16".freeze
      nationality_not_picked = "You must select a valid nationality".freeze
      document_not_picked = "You must select an option to continue".freeze

      add_date_of_birth(1, 2, Time.zone.now.year - 12)
      expect(page).to have_content(too_young)

      add_date_of_birth
      expect(page).to have_content("Enter their nationality")

      select("---", from: "unaccompanied-minor-adult-nationality-field")
      click_button("Continue")
      expect(page).to have_content(nationality_not_picked)

      enter_valid_nationality
      expect(page).to have_content("Do they have any of these identity documents?")

      click_button("Continue")
      expect(page).to have_content(document_not_picked)

      enter_valid_passport
      expect(page).to have_content(task_list_content)
    end

    it "retains the selected nationality over invocations" do
      add_date_of_birth
      enter_valid_nationality

      expect(page).to have_content("Do they have any of these identity documents?")

      visit "/sponsor-a-child/steps/30/123"

      expect(page).to have_select(
        "unaccompanied-minor-adult-nationality-field",
        selected: "Denmark",
      )
    end
  end

  def add_date_of_birth(day = 1, month = 2, year = Time.zone.now.year - 20)
    visit "/sponsor-a-child/task-list"
    expect(page).to have_content("Bob Jones details")

    click_link("Bob Jones details")
    expect(page).to have_content("Enter this person's date of birth")

    fill_in("Day", with: day)
    fill_in("Month", with: month)
    fill_in("Year", with: year)

    click_button("Continue")
  end

  def enter_valid_nationality
    expect(page).to have_content("Enter their nationality")
    select("Denmark", from: "unaccompanied_minor[adult_nationality]")

    click_button("Continue")
  end

  def enter_valid_passport
    expect(page).to have_content("Do they have any of these identity documents?")

    choose("Passport")
    fill_in("Passport number", with: "987654321")
    click_button("Continue")
  end
end
