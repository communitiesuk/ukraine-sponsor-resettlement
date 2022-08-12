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
    email = "test@email.com".freeze
    given_name = "First".freeze
    family_name = "Given".freeze

    sms_code = 123_456
    magic_id = "e5c4fe58-a8ca-4e6f-aaa6-7e0a381eb3dc".freeze
    expiry_time = (Time.zone.now.utc + 1.hour)

    uam = UnaccompaniedMinor.new
    uam.phone_number = phone_number
    uam.email = email
    uam.given_name = given_name
    uam.family_name = family_name
    uam.save!

    let(:texter) { instance_double("Notifications::Client") }
    let(:application_token) { instance_double("ApplicationToken") }
    let(:task_list_content) { "Apply for permission to sponsor a child fleeing Ukraine without a parent".freeze }

    before do
      allow(Notifications::Client).to receive(:new).and_return(texter)
      allow(texter).to receive(:send_sms)
      allow(ApplicationToken).to receive(:find_by).and_return(ApplicationToken.new({ token: sms_code, unaccompanied_minor: uam, magic_link: magic_id, expires_at: expiry_time }))
    end

    it "shows the confirm page if all info are entered" do
      page.set_rack_session(app_reference: uam.reference)
      visit "/sponsor-a-child/save-and-return"

      expect(page).to have_content("We've sent the link to the email address you have provided.")
    end

    it "redirects the user if contact info are missing" do
      uam.phone_number = nil
      uam.save!
      page.set_rack_session(app_reference: uam.reference)

      visit "/sponsor-a-child/save-and-return"

      expect(page).to have_content("What is your name?")
    end

    it "loads correct application given code" do
      params = { abstract_resume_token: { token: sms_code }, uuid: magic_id }

      page.driver.post "/sponsor-a-child/resume-application", params

      expect(page).to have_content(task_list_content)
    end
  end
end
