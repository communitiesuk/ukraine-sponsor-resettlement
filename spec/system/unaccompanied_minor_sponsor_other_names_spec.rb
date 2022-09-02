require "rails_helper"
require "securerandom"

RSpec.describe "Unaccompanied minor sponsor other names", type: :system do
  before do
    driven_by(:rack_test_user_agent)
  end

  describe "sponsor enters other names" do
    let(:task_list_content) { "Apply for approval to provide a safe home for a child from Ukraine".freeze }
    let(:first_other_given_name) { "Firstextra".freeze }
    let(:first_other_family_name) { "Firstfamily".freeze }
    let(:second_other_given_name) { "Secondextra".freeze }
    let(:second_other_family_name) { "Secondfamily".freeze }

    before do
      application = UnaccompaniedMinor.new
      application.save!

      page.set_rack_session(app_reference: application.reference)
    end

    def enter_sponsor_name_and_continue
      visit "/sponsor-a-child/start-application"
      expect(page).to have_content(task_list_content)

      click_link("Name")
      enter_name_and_continue("some", "name")
      expect(page).to have_content("Have you ever been known by another name?")
    end

    def enter_name_and_continue(given_name, family_name)
      fill_in("Given name(s)", with: given_name)
      fill_in("Family name", with: family_name)
      click_button("Continue")
    end

    it "when no other names are added go to task list" do
      enter_sponsor_name_and_continue
      choose("No")
      click_button("Continue")

      expect(page).to have_content(task_list_content)
    end

    it "when sponsor other given names is blank" do
      enter_sponsor_name_and_continue
      choose("Yes")
      click_button("Continue")

      enter_name_and_continue("", first_other_family_name)
      expect(page).to have_content("You must enter a valid given name")

      enter_name_and_continue(" ", first_other_family_name)
      expect(page).to have_content("You must enter a valid given name")
    end

    it "permits sponsor other given name of single character" do
      enter_sponsor_name_and_continue
      choose("Yes")
      click_button("Continue")

      enter_name_and_continue("A", first_other_family_name)
      expect(page).to have_content("You have added 1 other names")
      expect(page).to have_content("A")
    end

    it "when sponsor other family name is blank" do
      enter_sponsor_name_and_continue
      choose("Yes")
      click_button("Continue")

      enter_name_and_continue(first_other_given_name, "")
      expect(page).to have_content("You must enter a valid family name")

      enter_name_and_continue(first_other_given_name, " ")
      expect(page).to have_content("You must enter a valid family name")
    end

    it "permits sponsor other given family of single character" do
      enter_sponsor_name_and_continue
      choose("Yes")
      click_button("Continue")

      enter_name_and_continue(first_other_given_name, "B")
      expect(page).to have_content("You have added 1 other names")
      expect(page).to have_content("B")
    end

    it "on validation error it maintains valid name entries across requests" do
      enter_sponsor_name_and_continue
      choose("Yes")
      click_button("Continue")

      enter_name_and_continue(first_other_given_name, "")
      expect(page).to have_content("You must enter a valid family name")
      expect(page).to have_field("Given name(s)", with: first_other_given_name)

      enter_name_and_continue("", first_other_family_name)
      expect(page).to have_content("You must enter a valid given name")
      expect(page).to have_field("Family name", with: first_other_family_name)
    end

    it "shows both errors for family and given name together" do
      enter_sponsor_name_and_continue
      choose("Yes")
      click_button("Continue")

      enter_name_and_continue("", "")
      expect(page).to have_content("You must enter a valid family name")
      expect(page).to have_content("You must enter a valid given name")
    end

    it "when other names are entered" do
      enter_sponsor_name_and_continue
      choose("Yes")
      click_button("Continue")

      expect(page).to have_content("What is your other name?")

      enter_name_and_continue(first_other_given_name, first_other_family_name)
      expect(page).to have_content("You have added 1 other names")
      expect(page).to have_content(first_other_given_name)
      expect(page).to have_content(first_other_family_name)

      expected_first_remove_url = "/sponsor-a-child/remove-other-name/#{first_other_given_name}/#{first_other_family_name}".freeze
      expect(page).to have_link("Remove", href: expected_first_remove_url)

      click_link("Add another name")
      expect(page).to have_content("What is your other name?")
      enter_name_and_continue(second_other_given_name, second_other_family_name)

      expect(page).to have_content("You have added 2 other names")
      expect(page).to have_content(second_other_given_name)
      expect(page).to have_content(second_other_family_name)

      expected_second_remove_url = "/sponsor-a-child/remove-other-name/#{second_other_given_name}/#{second_other_family_name}".freeze
      expect(page).to have_link("Remove", href: expected_second_remove_url)

      click_link("Continue")
      expect(page).to have_content(task_list_content)
    end

    it "when other names are entered and all removed" do
      enter_sponsor_name_and_continue
      choose("Yes")
      click_button("Continue")

      expect(page).to have_content("What is your other name?")

      enter_name_and_continue(first_other_given_name, first_other_family_name)

      expect(page).to have_content("You have added 1 other names")
      expect(page).to have_content(first_other_given_name)
      expect(page).to have_content(first_other_family_name)

      expected_first_remove_url = "/sponsor-a-child/remove-other-name/#{first_other_given_name}/#{first_other_family_name}".freeze
      expect(page).to have_link("Remove", href: expected_first_remove_url)

      click_link("Add another name")
      expect(page).to have_content("What is your other name?")
      enter_name_and_continue(second_other_given_name, second_other_family_name)

      expect(page).to have_content("You have added 2 other names")
      expect(page).to have_content(second_other_given_name)
      expect(page).to have_content(second_other_family_name)

      expected_second_remove_url = "/sponsor-a-child/remove-other-name/#{second_other_given_name}/#{second_other_family_name}".freeze
      expect(page).to have_link("Remove", href: expected_second_remove_url)

      click_link(href: expected_second_remove_url)
      expect(page).to have_content("You have added 1 other names")
      expect(page).not_to have_content(second_other_given_name)
      expect(page).not_to have_content(second_other_family_name)

      click_link(href: expected_first_remove_url)
      expect(page).to have_content(task_list_content)
    end

    it "returns error message when no radio is clicked" do
      enter_sponsor_name_and_continue
      click_button("Continue")

      expect(page).to have_content("You must select an option")
    end
  end
end
