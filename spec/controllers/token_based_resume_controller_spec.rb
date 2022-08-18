require "rails_helper"

RSpec.describe TokenBasedResumeController, type: :controller do
  describe "User session times out" do
    given_name = "First".freeze
    email = "test@example.com".freeze

    uam = UnaccompaniedMinor.new
    uam.given_name = given_name
    uam.email = email

    uuid = "test-uuid".freeze
    magic_link = "http://test.host/sponsor-a-child/resume-application?uuid=#{uuid}".freeze

    let(:unaccompanied_minor) { instance_double("UnaccompaniedMinor") }
    let(:message_delivery) { instance_double("ActionMailer::MessageDelivery") }

    before do
      allow(SecureRandom).to receive(:uuid).and_return(uuid)
      allow(GovNotifyMailer).to receive(:send_save_and_return_email).and_return(message_delivery)
      allow(message_delivery).to receive(:deliver_later)
      allow(UnaccompaniedMinor).to receive(:find_by_reference).and_return(uam)
    end

    it "calls the emailer with the correct params" do
      get :session_expired

      expect(GovNotifyMailer).to have_received(:send_save_and_return_email).with(given_name, magic_link, email)
      expect(response).to render_template("token-based-resume/session_expired")
    end
  end

  describe "User tries to resume their application after email sent" do
    phone_number = "07983111111".freeze
    sms_code = 123_456
    magic_id = "e5c4fe58-a8ca-4e6f-aaa6-7e0a381eb3dc".freeze
    expiry_time = (Time.zone.now.utc + 1.hour)
    created_at = Time.zone.now.utc

    uam = UnaccompaniedMinor.new
    uam.phone_number = phone_number

    let(:texter) { instance_double("Notifications::Client") }
    let(:application_token) { instance_double("ApplicationToken") }

    before do
      allow(Notifications::Client).to receive(:new).and_return(texter)
      allow(texter).to receive(:send_sms)
      allow(ApplicationToken).to receive(:find_by).and_return(ApplicationToken.new({ token: sms_code, unaccompanied_minor: uam, magic_link: magic_id, expires_at: expiry_time, created_at: }))
    end

    it "calls the texter with the correct params" do
      get :display, params: { uuid: magic_id }

      expect(texter).to have_received(:send_sms).with({ personalisation: { OTP: sms_code.to_s }, phone_number:, template_id: "b51a151e-f352-473a-b52e-185d2873cbf5" })
    end

    it "load correct application given code" do
      parms = { abstract_resume_token: { token: sms_code }, uuid: magic_id }

      post :submit, params: parms

      expect(response.status).to eq(200)
      puts flash[:error]
      expect(response).to render_template("sponsor-a-child/task_list")
    end
  end

  describe "User errors" do
    it "gets error when sms code is not entered" do
      magic_id = "e5c4fe58-a8ca-4e6f-aaa6-7e0a381eb3dc".freeze
      parms = { abstract_resume_token: { token: "" }, uuid: magic_id }

      post :submit, params: parms

      expect(response.status).to eq(200)
      expect(response).to render_template("token-based-resume/session_resume_form")
      expect(flash[:error]).to eq("Please enter a valid code")
    end

    it "shows an error when sms code is not numeric" do
      magic_id = "e5c4fe58-a8ca-4e6f-aaa6-7e0a381eb3dc".freeze
      non_numeric_code = "ABCDEF".freeze
      parms = { abstract_resume_token: { token: non_numeric_code }, uuid: magic_id }

      post :submit, params: parms

      expect(response.status).to eq(200)
      expect(response).to render_template("token-based-resume/session_resume_form")
      expect(flash[:error]).to eq("Please enter a valid code")
    end

    it "shows an error when sms code is entered but no application exists for the code" do
      magic_id = "e5c4fe58-a8ca-4e6f-aaa6-7e0a391eb3dc".freeze
      non_numeric_code = "665312".freeze
      parms = { abstract_resume_token: { token: non_numeric_code }, uuid: magic_id }

      post :submit, params: parms

      expect(response.status).to eq(302)
      expect(response).to redirect_to("/sponsor-a-child/resume-application?uuid=#{magic_id}")
      expect(flash[:error]).to eq("No application found for this code")
    end
  end

  describe "user takes too long to return" do
    phone_number = "07983111111".freeze
    sms_code = 123_456
    magic_id = "e5c4fe58-a8ca-4e6f-aaa6-7e0a381eb3dc".freeze
    expiry_time = (Time.zone.now.utc - 1.hour)
    created_at = Time.zone.now.utc

    uam = UnaccompaniedMinor.new
    uam.phone_number = phone_number

    let(:texter) { instance_double("Notifications::Client") }
    let(:application_token) { instance_double("ApplicationToken") }

    before do
      allow(Notifications::Client).to receive(:new).and_return(texter)
      allow(texter).to receive(:send_sms)
      allow(ApplicationToken).to receive(:find_by).and_return(ApplicationToken.new({ token: sms_code, unaccompanied_minor: uam, magic_link: magic_id, expires_at: expiry_time, created_at: }))
    end

    it "shows an error when sms code is timed out" do
      magic_id = "e5c4fe58-a8ca-4e6f-aaa6-7e0a381eb3dc".freeze
      numeric_code = 123_456
      parms = { abstract_resume_token: { token: numeric_code }, uuid: magic_id }

      post :submit, params: parms

      expect(response.status).to eq(302)
      expect(response).to redirect_to("/sponsor-a-child/resume-application?uuid=#{magic_id}")
      expect(flash[:error]).to eq("This code has timed out, please request a new one")
    end
  end
end
