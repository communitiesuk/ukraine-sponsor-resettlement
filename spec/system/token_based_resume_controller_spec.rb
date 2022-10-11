require "rails_helper"

RSpec.describe TokenBasedResumeController, type: :system do
  let(:texter) { instance_double("Notifications::Client") }
  let(:application_token) { instance_double("ApplicationToken") }
  let(:task_list_content) { "Apply for approval to provide a safe home for a child from Ukraine".freeze }
  let(:sms_code) { 123_456 }
  let(:already_expired) { Time.zone.now.utc - 1.hour }
  let(:created_at) { Time.zone.now.utc }
  let(:magic_id) { "e5c4fe58-a8ca-4e6f-aaa6-7e0a381eb3dc" }
  let(:expiry_time) { Time.zone.now.utc + 1.hour }
  let(:uam) { UnaccompaniedMinor.new }

  before do
    driven_by(:rack_test_user_agent)
    allow(Notifications::Client).to receive(:new).and_return(texter)
    allow(texter).to receive(:send_sms)
    allow(UnaccompaniedMinor).to receive(:find_by_email).and_return(uam)
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
      uam = UnaccompaniedMinor.new
      uam.save!
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
    uam = UnaccompaniedMinor.new
    uam.save!

    before do
      allow(Notifications::Client).to receive(:new).and_return(texter)
      allow(texter).to receive(:send_sms)
      allow(UnaccompaniedMinor).to receive(:find_by_email).and_return(uam)
      allow(ApplicationToken).to receive(:find_by).and_return(ApplicationToken.new({ token: sms_code, unaccompanied_minor: uam, magic_link: magic_id, expires_at: expiry_time, created_at: }))
    end

    it "shows the confirm page if required data is present" do
      uam_enter_valid_complete_eligibility_section
      uam_start_page_to_task_list
      uam_click_task_list_link("Name")
      uam_enter_sponsor_name
      uam_enter_sponsor_not_known_by_another_name
      uam_click_task_list_link("Contact details")
      uam_enter_sponsor_contact_details

      visit "/sponsor-a-child/save-and-return"

      expect(page).to have_content("We've sent the link to")
    end

    it "redirects the user to additional details form if email info are missing" do
      uam.given_name = given_name
      uam.email = nil
      uam.save!
      page.set_rack_session(app_reference: uam.reference)

      visit "/sponsor-a-child/save-and-return"

      expect(page).to have_content(I18n.t("email.short", scope: "unaccompanied_minor.questions"))
    end

    it "redirects the user to additional details form if phone number info are missing" do
      uam.given_name = given_name
      uam.email = email
      uam.phone_number = nil
      uam.save!
      page.set_rack_session(app_reference: uam.reference)

      visit "/sponsor-a-child/save-and-return"

      expect(page).to have_content(I18n.t("phone_number.full", scope: "unaccompanied_minor.questions"))
    end

    it "redirects to start page if no application is present" do
      visit "/sponsor-a-child/save-and-return"

      expect(page).to have_content("Apply to provide a safe home for a child from Ukraine")
    end

    it "allows the user to resume an application if the correct email is provided" do
      page.set_rack_session(app_reference: uam.reference)

      visit "/sponsor-a-child/save-and-return/resend-link"

      fill_in("Email address", with: email)
      click_button("Send Link")

      expect(page).to have_content("We've sent the link to #{email_scrambled}")
    end

    it "allows the user to resume an application if given_name is not provided" do
      uam.given_name = nil
      uam.email = email
      uam.phone_number = phone_number
      uam.save!
      page.set_rack_session(app_reference: uam.reference)

      visit "/sponsor-a-child/save-and-return/resend-link"

      fill_in("Email address", with: email)
      click_button("Send Link")

      expect(page).to have_content("We've sent the link to #{email_scrambled}")
    end

    it "shows an error if the email is invalid" do
      page.set_rack_session(app_reference: uam.reference)

      visit "/sponsor-a-child/save-and-return/resend-link"

      fill_in("Email address", with: "")
      click_button("Send Link")

      expect(page).to have_content(I18n.t(:invalid_email, scope: :error))
    end

    it "shows an error box if the email is invalid" do
      page.set_rack_session(app_reference: uam.reference)

      visit "/sponsor-a-child/save-and-return/resend-link"

      fill_in("Email address", with: "")
      click_button("Send Link")

      expect(page).to have_content("There is a problem")
    end

    it "loads correct application given code" do
      uam.given_name = given_name
      uam.phone_number = phone_number
      uam.email = email
      uam.save!

      UnaccompaniedMinor.where.not(reference: uam.reference).destroy_all
      params = { abstract_resume_token: { token: sms_code }, uuid: magic_id }

      page.driver.post "/sponsor-a-child/resume-application", params

      expect(page).to have_content(task_list_content)
      uam_click_task_list_link("Name")
      expect(page).to have_content(given_name)
    end
  end
end
