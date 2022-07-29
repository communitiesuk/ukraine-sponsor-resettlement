require "rails_helper"

RSpec.describe TokenBasedResumeController, type: :controller do
  describe "User tries to resume their application" do
    phone_number = "07983111111".freeze
    sms_code = "123456".freeze
    magic_id = "e5c4fe58-a8ca-4e6f-aaa6-7e0a381eb3dc".freeze

    uam = UnaccompaniedMinor.new
    uam.phone_number = phone_number

    let(:texter) { instance_double("Notifications::Client") }
    let(:application_token) { instance_double("ApplicationToken") }

    before do
      allow(Notifications::Client).to receive(:new).and_return(texter)
      allow(texter).to receive(:send_sms)
      allow(ApplicationToken).to receive(:find_by).and_return(ApplicationToken.new({ token: sms_code, unaccompanied_minor: uam, magic_link: magic_id }))
    end

    it "calls the texter with the correct params" do
      get :display, params: { uuid: magic_id }

      expect(texter).to have_received(:send_sms).with({ personalisation: { OTP: sms_code }, phone_number:, template_id: "b51a151e-f352-473a-b52e-185d2873cbf5" })
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
      expect(response).to redirect_to("/sponsor-a-child/resume-application?uuid=e5c4fe58-a8ca-4e6f-aaa6-7e0a391eb3dc")
      expect(flash[:error]).to eq("No application found for this code")
    end
  end
end
