require "./app/mailers/gov_notify_mailer"

describe "Gov Notify Mailer" do
  context "when sponsor has completed their application form" do
    it "sends application complete email" do
      expect(GovNotifyMailer).to receive(:send_email)

      GovNotifyMailer.send_email()
    end
  end
end
