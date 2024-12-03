require "rails_helper"

RSpec.describe TokenBasedResumeController, type: :system do
  let(:spencer_scrambled) { "s**************@example.com" }
  let(:email_scrambled) { "t***@example.com" }
  let(:email) { "test@example.com" }
  let(:uam) { UnaccompaniedMinor.new }
  let(:expiry_time) { Time.zone.now.utc + 1.hour }
  let(:magic_id) { "e5c4fe58-a8ca-4e6f-aaa6-7e0a381eb3dc" }
  let(:created_at) { Time.zone.now.utc }
  let(:already_expired) { Time.zone.now.utc - 1.hour }
  let(:sms_code) { 123_456 }
  let(:task_list_content) { "Apply for approval to provide a safe home for a child from Ukraine" }
  let(:application_token) { instance_double(ApplicationToken) }
  let(:texter) { instance_double(Notifications::Client) }

  before do
    driven_by(:rack_test_user_agent)
    allow(Notifications::Client).to receive(:new).and_return(texter)
    allow(texter).to receive(:send_sms)
  end

  describe "User hasn't created an account and has been timed out" do
    let(:email) { nil }

    it "shows time out page if user refresh time out page" do
      new_application = UnaccompaniedMinor.new
      new_application.save!

      page.set_rack_session(app_reference: new_application.reference)

      visit "/sponsor-a-child/session-expired"
      visit current_path

      expect(page).to have_content("Your session has timed out due to inactivity")
    end
  end

  describe "User has been timed out" do
    it "shows time out page and copy" do
      new_application = UnaccompaniedMinor.new
      new_application.save!

      page.set_rack_session(app_reference: new_application.reference)

      visit "/sponsor-a-child/session-expired"

      expect(page).to have_content("Your session has timed out due to inactivity")
    end
  end

  describe "User token is expired" do
    before do
      allow(ApplicationToken).to receive(:find_by).and_return(ApplicationToken.new({ token: sms_code, unaccompanied_minor: uam, magic_link: magic_id, expires_at: already_expired, created_at: }))
    end

    it "shows an error to the user" do
      visit "/sponsor-a-child/resume-application?uuid=#{magic_id}"

      expect(page).to have_content("This code has expired")
      expect(page).to have_content("This code has expired, please request a new one")
    end

    it "allows the user to request a new token" do
      visit "/sponsor-a-child/save-and-return/resend-token?uuid=#{magic_id}"

      expect(page).to have_content("We've sent a 6-digit code to your phone")

      application_token = ApplicationToken.find_by(magic_link: magic_id)

      expect(application_token.expires_at).not_to eq(already_expired)
      expect(application_token.token).not_to eq(sms_code)
    end
  end

  describe "User intentionally resumes their application" do
    it "shows the confirm page if required data is present" do
      uam_enter_valid_complete_eligibility_section
      uam_start_page_to_task_list
      uam_click_task_list_link("Name")
      uam_enter_sponsor_name
      uam_enter_sponsor_not_known_by_another_name
      uam_click_task_list_link("Contact details")
      uam_enter_sponsor_contact_details
      visit "/sponsor-a-child/save-and-return"

      expect(page).to have_content("We've sent the link to #{spencer_scrambled}")
    end

    it "redirects the user to additional details form if email info are missing" do
      uam_enter_valid_complete_eligibility_section
      uam_start_page_to_task_list
      uam_click_task_list_link("Name")
      uam_enter_sponsor_name
      uam_enter_sponsor_not_known_by_another_name
      visit "/sponsor-a-child/save-and-return"

      expect(page).to have_content(I18n.t("email.short", scope: "unaccompanied_minor.questions"))
    end

    it "redirects the user to additional details form if phone number info are missing" do
      uam_enter_valid_complete_eligibility_section
      uam_start_page_to_task_list
      uam_click_task_list_link("Name")
      uam_enter_sponsor_name
      uam_enter_sponsor_not_known_by_another_name
      uam_click_task_list_link("Contact details")

      expect(page).to have_content("Enter your email address")

      fill_in("Email", with: "spencer.sponsor@example.com")
      fill_in("unaccompanied_minor[email_confirm]", with: "spencer.sponsor@example.com")
      click_on("Continue")

      expect(page).to have_content("Enter your UK mobile number")

      visit "/sponsor-a-child/save-and-return"

      expect(page).to have_content(I18n.t("phone_number.full", scope: "unaccompanied_minor.questions"))
    end

    it "redirects to start page if no application is present" do
      visit "/sponsor-a-child/save-and-return"

      expect(page).to have_content("Apply to provide a safe home for a child from Ukraine")
    end

    it "allows the user to resume an application if the correct email is provided" do
      visit "/sponsor-a-child/save-and-return/resend-link"

      fill_in("Email address", with: email)
      click_button("Send Link")

      expect(page).to have_content("We've sent the link to #{email_scrambled}")
    end

    it "allows the user to resume an application if given_name is not provided" do
      uam_enter_valid_complete_eligibility_section
      uam_start_page_to_task_list
      uam_click_task_list_link("Contact details")
      uam_enter_sponsor_contact_details

      visit "/sponsor-a-child/save-and-return"
      visit "/sponsor-a-child/save-and-return/resend-link"

      fill_in("unaccompanied-minor-email-field", with: email)
      click_button("Send Link")

      expect(page).to have_content("We've sent the link to #{email_scrambled}")
    end

    it "shows an error with error box if the email is invalid" do
      page.set_rack_session(app_reference: uam.reference)

      visit "/sponsor-a-child/save-and-return/resend-link"

      fill_in("Email address", with: "")
      click_button("Send Link")

      expect(page).to have_content("There is a problem")
      expect(page).to have_content(I18n.t(:invalid_email, scope: :error))
    end

    it "loads correct application given code" do
      uam_enter_valid_complete_eligibility_section
      uam_start_page_to_task_list
      uam_click_task_list_link("Name")
      uam_enter_sponsor_name
      uam_enter_sponsor_not_known_by_another_name
      uam_click_task_list_link("Contact details")
      uam_enter_sponsor_contact_details

      visit "/sponsor-a-child/save-and-return"

      page.driver.post("/sponsor-a-child/resume-application", token_resume_params)

      expect(page.body).to have_text("Name")
      visit "/sponsor-a-child/task-list"
      click_on("Name")
      expect(page).to have_field("Given names", with: "Spencer")
    end

    def token_resume_params
      app_ref = page.get_rack_session_key("app_reference")
      UnaccompaniedMinor.where.not(reference: app_ref).destroy_all
      application = UnaccompaniedMinor.find_by_reference(app_ref)
      app_token = ApplicationToken.find_by(unaccompanied_minor: application)

      { abstract_resume_token: { token: app_token.token }, uuid: app_token.magic_link }
    end
  end

  describe "user tries to return without an application present" do
    it "redirects them to the start page" do
      visit "/sponsor-a-child/resume-application"

      expect(page).to have_content("Use this service to apply for approval to sponsor a child fleeing Ukraine, who is not travelling with or joining their parent or legal guardian in the UK.")
    end
  end
end
