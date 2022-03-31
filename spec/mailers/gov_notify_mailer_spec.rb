require "rails_helper"

RSpec.describe GovNotifyMailer do
  before do
    ENV["INDIVIDUAL_CONFIRMATION_TEMPLATE_ID"] = "6c80930d-e25a-4dc6-8383-bb83a2c18d19"
  end

  describe "Send individual email" do
    it "when submitting individual expression of interest form" do
      application = IndividualExpressionOfInterest.new

      application.fullname = "Bob Smith-Jones"
      application.reference = "my-reference"
      application.email = "my-email@test.com"

      response = GovNotifyMailer.send_individual_confirmation_email(application).deliver_now

      expect(response.govuk_notify_response.template.fetch("id")).to eq("6c80930d-e25a-4dc6-8383-bb83a2c18d19")
      expect(response.govuk_notify_response.id).not_to be_empty
    end

    it "when sending email with invalid email address" do
      application = IndividualExpressionOfInterest.new

      application.fullname = "Bob Smith-Jones"
      application.reference = "my-reference"
      application.email = "invalid-email-address@test"

      expect{GovNotifyMailer.send_individual_confirmation_email(application).deliver_now}.to raise_error
    end
  end
end
