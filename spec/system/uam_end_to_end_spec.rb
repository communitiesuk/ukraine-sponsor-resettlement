RSpec.describe "Unaccompanied minor full journey", type: :system do
  let(:task_list_path) { "/sponsor-a-child/task-list" }
  let(:task_list_content) { "Apply for approval to provide a safe home for a child from Ukraine" }
  let(:minors_email) { "unaccompanied.minor@test.com" }
  let(:minors_phone) { "07983111111" }
  let(:minors_dob) { Time.zone.now - 4.years }

  before do
    driven_by(:rack_test_user_agent)
    # new_application = UnaccompaniedMinor.new
    # new_application.save!
    #
    # page.set_rack_session(app_reference: new_application.reference)
  end

  describe "entering minimum valid details" do
    it "creates valid JSON to transfer to foundry" do
      uam_complete_eligibity_section
      uam_start_page_to_task_list
      uam_enter_sponsor_name
      # navigate_to_child_personal_details_name_entry
      # enter_name_and_continue
      # enter_contact_details_and_continue(email: minors_email, confirm_email: minors_email)
      # enter_date_of_birth_and_continue
      # expect(page).to have_content("completed").once
    end
  end

  def navigate_to_task_list
    visit task_list_path
    expect(page).to have_content(task_list_content)
  end

  def navigate_to_child_personal_details_name_entry
    navigate_to_task_list

    click_link("Child's personal details")

    expect(page).to have_content("Enter the name of the child you want to sponsor")
  end

  def enter_contact_details_and_continue(email: nil, confirm_email: nil, telephone: nil, confirm_telephone: nil, select_none: false)
    if email.present? || confirm_email.present?
      check("Email")
    end

    if email.present?
      fill_in("Email", with: email)
    end

    if confirm_email.present?
      fill_in("unaccompanied_minor[minor_email_confirm]", with: confirm_email)
    end

    if telephone.present?
      check("Phone")
      fill_in("Phone number", with: telephone)
    end

    if confirm_telephone.present?
      fill_in("unaccompanied_minor[minor_phone_number_confirm]", with: confirm_telephone)
    end

    if select_none
      check("They cannot be contacted")
    end

    click_button("Continue")
  end

  def enter_date_of_birth_and_continue
    fill_in("Day", with: minors_dob.day)
    fill_in("Month", with: minors_dob.month)
    fill_in("Year", with: minors_dob.year)

    click_button("Continue")
  end
end
