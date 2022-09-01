require "rails_helper"

RSpec.describe TokenBasedResumeController, type: :system do
  before do
    driven_by(:rack_test_user_agent)
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

  describe "User intentionally resumes their application" do
    phone_number = "07983111111".freeze
    email = "test@example.com".freeze
    email_scrambled = "t***@example.com".freeze
    given_name = "Given".freeze
    family_name = "Family".freeze

    sms_code = 123_456
    magic_id = "e5c4fe58-a8ca-4e6f-aaa6-7e0a381eb3dc".freeze
    expiry_time = (Time.zone.now.utc + 1.hour)
    created_at = Time.zone.now.utc

    uam = UnaccompaniedMinor.new(
      given_name:,
      family_name:,
      email:,
      phone_number:,
    )
    uam.save!

    let(:texter) { instance_double("Notifications::Client") }
    let(:application_token) { instance_double("ApplicationToken") }
    let(:task_list_content) { "Apply for permission to sponsor a child fleeing Ukraine without a parent".freeze }

    before do
      allow(Notifications::Client).to receive(:new).and_return(texter)
      allow(texter).to receive(:send_sms)
      allow(UnaccompaniedMinor).to receive(:find_by_email).and_return(uam)
      allow(ApplicationToken).to receive(:find_by).and_return(ApplicationToken.new({ token: sms_code, unaccompanied_minor: uam, magic_link: magic_id, expires_at: expiry_time, created_at: }))
    end

    it "shows the confirm page if required data is present" do
      uam.email = email
      uam.save!
      page.set_rack_session(app_reference: uam.reference)
      visit "/sponsor-a-child/save-and-return"

      expect(page).to have_content("We've sent the link to #{email_scrambled}")
    end

    it "redirects the user to additional details form if email info are missing" do
      uam.given_name = given_name
      uam.email = nil
      uam.save!
      page.set_rack_session(app_reference: uam.reference)

      visit "/sponsor-a-child/save-and-return"

      expect(page).to have_content(I18n.t("email.full", scope: "unaccompanied_minor.questions"))
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

    it "allows the user to resume an application if the correct email is provided" do
      page.set_rack_session(app_reference: uam.reference)

      visit "/sponsor-a-child/save-and-return/resend-link"

      fill_in("Enter an email address that you have access to, so you can save and continue your application later.", with: email)
      click_button("Send Link")

      expect(page).to have_content("We've sent the link to #{email_scrambled}")
    end

    it "shows an error if the email is invalid" do
      page.set_rack_session(app_reference: uam.reference)

      visit "/sponsor-a-child/save-and-return/resend-link"

      fill_in("Enter an email address that you have access to, so you can save and continue your application later.", with: "")
      click_button("Send Link")

      expect(page).to have_content(I18n.t(:invalid_email, scope: :error))
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
    end
  end
end
