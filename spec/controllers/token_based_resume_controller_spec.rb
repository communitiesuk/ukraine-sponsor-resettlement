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

    it "routes to send_token" do
      get :display, params: { magic_link: magic_id }

      expect(texter).to have_received(:send_sms).with({ personalisation: { OTP: sms_code }, phone_number:, template_id: "b51a151e-f352-473a-b52e-185d2873cbf5" })
    end
  end
end
