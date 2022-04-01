require "rails_helper"

# RSpec.describe GovNotifyMailer do
#   before do
#     ENV["INDIVIDUAL_CONFIRMATION_TEMPLATE_ID"] = "6c80930d-e25a-4dc6-8383-bb83a2c18d19"
#     ENV["ORGANISATION_CONFIRMATION_TEMPLATE_ID"] = "3ae2501f-e2be-4ad6-886b-fcf5aa71d448"
#   end
#
#   describe "Send individual email" do
#     it "when submitting individual expression of interest form" do
#       application = IndividualExpressionOfInterest.new
#
#       application.fullname = "Bob Smith-Jones"
#       application.reference = "my-reference"
#       application.email = "my-email@test.com"
#
#       response = described_class.send_individual_confirmation_email(application).deliver_now
#
#       expect(response.govuk_notify_response.template.fetch("id")).to eq("6c80930d-e25a-4dc6-8383-bb83a2c18d19")
#       expect(response.govuk_notify_response.id).not_to be_empty
#     end
#
#     it "when sending email with invalid email address" do
#       application = IndividualExpressionOfInterest.new
#
#       application.fullname = "Bob Smith-Jones"
#       application.reference = "my-reference"
#       application.email = "wheezr069@gmail"
#
#       response = described_class.send_individual_confirmation_email(application).deliver_now
#
#       expect(response).to be_nil
#     end
#   end
#
#   describe "Send organisation email" do
#     it "when submitting organisation expression of interest form" do
#       application = OrganisationExpressionOfInterest.new
#
#       application.fullname = "Bob Smith-Jones"
#       application.reference = "my-reference"
#       application.email = "my-email@test.com"
#
#       response = described_class.send_organisation_confirmation_email(application).deliver_now
#
#       expect(response.govuk_notify_response.template.fetch("id")).to eq("3ae2501f-e2be-4ad6-886b-fcf5aa71d448")
#       expect(response.govuk_notify_response.id).not_to be_empty
#     end
#
#     it "when sending email with invalid email address" do
#       application = OrganisationExpressionOfInterest.new
#
#       application.fullname = "Bob Smith-Jones"
#       application.reference = "my-reference"
#       application.email = "wheezr069@gmail"
#
#       response = described_class.send_organisation_confirmation_email(application).deliver_now
#
#       expect(response).to be_nil
#     end
#   end
# end
