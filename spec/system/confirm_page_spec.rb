RSpec.describe "Unaccompanied minor other adults", type: :system do
  describe "user completes their application with minimum valid details" do
    before do
      driven_by(:rack_test_user_agent)
    end

    it "shows reference number on confirm page" do
      uam_enter_valid_complete_eligibity_section
      uam_start_page_to_task_list

      uam_click_task_list_link("Name")
      uam_enter_sponsor_name
      uam_sponsor_known_by_another_name
      check_sections_complete(0)

      uam_click_task_list_link("Contact details")
      uam_enter_sponsor_contact_details
      check_sections_complete(0)

      uam_click_task_list_link("Additional details")
      uam_enter_sponsor_additional_details
      check_sections_complete(1)

      uam_click_task_list_link("Address")
      uam_enter_residential_address
      check_sections_complete(2)

      uam_click_task_list_link("Child's personal details")
      uam_enter_childs_personal_details
      check_sections_complete(2)

      uam_click_task_list_link("Upload UK consent form")
      uam_upload_consent_forms
      check_sections_complete(3)

      uam_click_task_list_link("Confirm we can use your data")
      uam_confirm_privacy_statement

      uam_click_task_list_link("Confirm your eligibility")
      uam_confirm_eligibilty
      check_sections_complete(4)

      uam_click_task_list_link("Check your answers and send")
      uam_check_answers_and_submit

      assert_transfer_json_is_valid

      visit "/sponsor-a-child/confirm"
      expect(page).to have_content("SPON-")

      page.set_rack_session(app_reference: nil)
      visit "/sponsor-a-child/confirm"
      expect(page).to have_content("Use this service to apply for approval to sponsor a child fleeing Ukraine, who is not travelling with or joining their parent or legal guardian in the UK.")
    end

    def check_sections_complete(complete_sections)
      expect(page).to have_content("You have completed #{complete_sections} of 4 sections.")
    end

    def assert_transfer_json_is_valid
      app_ref = page.get_rack_session_key("app_reference")
      application = UnaccompaniedMinor.find_by_reference(app_ref)
      json = application.prepare_transfer

      expect(json).to match_schema("unaccompanied_minor")
    end
  end
end
