require "./spec/rails_helper"
require "./app/models/application"
require "./app/mailers/gov_notify_mailer"

describe "Gov Notify Mailer" do
  context "when sponsor has completed their application form" do
    it "sends application complete email with personalisation" do
      let(:notify_client) { instance_double(Notifications::Client) }
      let(:application) { instance_double("Application", :reference => "the-reference") }

      expect(GovNotifyMailer).to receive(:send_email).with(
          "no-one@test.com", "6c80930d-e25a-4dc6-8383-bb83a2c18d19", {
              fullname: "Bob Jones",
              reference: "the-reference"
          }
      )

      GovNotifyMailer.send_individual_confirmation_email(:application)
    end
  end
end
