require "./app/mailers/gov_notify_mailer"

TEMPLATE_ID = "6c80930d-e25a-4dc6-8383-bb83a2c18d19"

describe "Gov Notify Mailer" do
  context "when sponsor has completed their application form" do
    it "sends application complete email" do
      expect(GovNotifyMailer).to receive(:send_email).with(
          "no-one@test.com", "6c80930d-e25a-4dc6-8383-bb83a2c18d19"
          )

      GovNotifyMailer.send_email("no-one@test.com", TEMPLATE_ID)
    end

    it "sends application complete email with personalisation" do
      personalisation = { fullname: "Bob Jones", reference: "the-reference" }

      expect(GovNotifyMailer).to receive(:send_email).with(
          "no-one@test.com", "6c80930d-e25a-4dc6-8383-bb83a2c18d19", {
              fullname: "Bob Jones",
              reference: "the-reference"
          }
      )

      GovNotifyMailer.send_email("no-one@test.com", TEMPLATE_ID, personalisation)
    end
  end
end
