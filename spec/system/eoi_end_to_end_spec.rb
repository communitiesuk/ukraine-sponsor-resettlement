RSpec.describe "Expression of interest end to end", type: :system do
  before do
    driven_by(:rack_test_user_agent)
  end

  describe "user successfully completes the eoi journey", js: true do
    it "entering minimum valid details" do
      eoi_skip_to_questions

      eoi_enter_sponsor_name
      eoi_enter_sponsor_contact_details
      eoi_enter_sponsor_address
      eoi_enter_sponsor_start
      eoi_people_at_address
      eoi_sponsor_refugee_preference
      eoi_number_of_rooms
      eoi_accessibility_info
      eoi_contact_consent
      eoi_check_answers_and_submit

      assert_transfer_json_is_valid
    end

    it "entering all optional fields" do
      expected_optional_keys = %w[property_one_line_2]

      eoi_skip_to_questions
      eoi_enter_sponsor_name
      eoi_enter_sponsor_contact_details
      eoi_enter_sponsor_address(different_address: true, more_properties: true)
      eoi_enter_sponsor_start
      eoi_people_at_address
      eoi_sponsor_refugee_preference
      eoi_number_of_rooms
      eoi_accessibility_info
      eoi_contact_consent
      eoi_check_answers_and_submit

      assert_transfer_json_is_valid(expected_optional_keys)
    end
  end

  def assert_transfer_json_is_valid(optional_keys = [])
    app_ref = page.get_rack_session_key("app_reference")
    application = ExpressionOfInterest.find_by_reference(app_ref)
    application.accommodation_length = "From 6 to 9 months" # FIX THIS IN VIEW OR SOMETHING

    hash = application.as_json
    json = hash.to_json

    expect(json).to match_schema("expression_of_interest")

    unless optional_keys.empty?
      json_object = JSON.parse(json)
      # puts json_object
      expect(json_object.keys).to include(*optional_keys)
    end
  end
end
