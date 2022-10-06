RSpec.describe "Unaccompanied minor other adults", type: :system do
  describe "user completes their application with minimum valid details" do
    before do
      driven_by(:rack_test_user_agent)
    end

    it "shows reference number on confirm page" do
      uam_enter_valid_complete_eligibility_section
      uam_start_page_to_task_list

      uam_click_task_list_link("Name")
      uam_enter_sponsor_name
      uam_enter_sponsor_not_known_by_another_name
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
  end

  describe "user completes their application with MAX valid details" do
    before do
      driven_by(:rack_test_user_agent)
    end

    it "whole end to end journey" do
      optional_keys = %w[other_names
                         no_identification_reason
                         other_nationalities
                         sponsor_address_line_1
                         sponsor_address_line_2
                         sponsor_address_town
                         sponsor_address_postcode
                         adults_at_address]

      uam_enter_valid_complete_eligibility_section
      uam_start_page_to_task_list

      uam_click_task_list_link("Name")
      uam_enter_sponsor_name
      uam_enter_sponsor_other_name
      check_sections_complete(0)

      uam_click_task_list_link("Contact details")
      uam_enter_sponsor_contact_details
      check_sections_complete(0)

      uam_click_task_list_link("Additional details")
      uam_enter_sponsor_additional_details(id_option: "I don't have any of these", other_nationalities: %w[Albania Aruba])
      check_sections_complete(1)

      uam_click_task_list_link("Address")
      uam_enter_residential_address(different_address: true)
      check_sections_complete(3, sections: 5)

      uam_click_task_list_link("Child's personal details")
      uam_enter_childs_personal_details
      check_sections_complete(3, sections: 5)

      uam_click_task_list_link("Upload UK consent form")
      uam_upload_consent_forms
      check_sections_complete(4, sections: 5)

      uam_click_task_list_link("Confirm we can use your data")
      uam_confirm_privacy_statement

      uam_click_task_list_link("Confirm your eligibility")
      uam_confirm_eligibilty
      check_sections_complete(5, sections: 5)

      uam_click_task_list_link("Check your answers and send")
      uam_check_answers_and_submit

      assert_transfer_json_is_valid(optional_keys)

      visit "/sponsor-a-child/confirm"
      expect(page).to have_content("SPON-")

      page.set_rack_session(app_reference: nil)
      visit "/sponsor-a-child/confirm"
      expect(page).to have_content("Use this service to apply for approval to sponsor a child fleeing Ukraine, who is not travelling with or joining their parent or legal guardian in the UK.")
    end

    def check_sections_complete(completed_sections, sections: 4)
      expect(page).to have_content("You have completed #{completed_sections} of #{sections} sections.")
    end
  end

  def assert_transfer_json_is_valid(optional_keys = [])
    app_ref = page.get_rack_session_key("app_reference")
    application = UnaccompaniedMinor.find_by_reference(app_ref)
    json = application.prepare_transfer

    expect(json).to match_schema("unaccompanied_minor")

    unless optional_keys.empty?
      json_object = JSON.parse(json)
      # puts json_object
      expect(json_object.keys).to include(*optional_keys)
    end
  end
end
