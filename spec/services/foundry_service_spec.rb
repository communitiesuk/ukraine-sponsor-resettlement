require "rails_helper"

RSpec.describe FoundryService do
  describe "calling the FoundryService to link uploaded files" do
    let(:application_reference) { "SPON-1234-42EC-Z" }
    let(:upload_rid) { "uploaded.rid.is.some.long.string" }
    let(:api_url) { "https://example.com/api" }
    let(:api_token) { "some_api_token" }
    let(:time_now) { Time.zone.local(1970, 1, 1) }
    let(:response) { Net::HTTPResponse.new(1.0, 200, "OK") }

    before do
      allow(Time).to receive(:now).and_return(time_now)
      allow(Net::HTTP).to receive(:post).and_return(response)
    end

    it "generates the correct json payload" do
      expected_json = {
        parameters: {
          type: "unaccompanied_minor_attachment_uk_consent",
          created_at: time_now.utc.strftime("%F %T"),
          form_reference: application_reference,
          rid: upload_rid,
        },
      }.to_json

      expect(described_class.json_payload("uk", application_reference, upload_rid))
      .to eq(expected_json)
    end

    it "posts to foundry to link the uk consent form" do
      consent_transfer = described_class.new(api_url, api_token)
      consent_transfer.assign_uploaded_uk_consent_form(application_reference, upload_rid)

      expect(Net::HTTP).to have_received(:post).with(
        api_url,
        satisfy { |json| json_payload_contains_ref_and_rid(json) },
        {
          "Authorization" => "Bearer #{api_token}",
          "Content-Type" => "application/json",
        },
      )
    end

    it "posts to foundry to link the ukraine consent form" do
      consent_transfer = described_class.new(api_url, api_token)
      consent_transfer.assign_uploaded_ukraine_consent_form(application_reference, upload_rid)

      expect(Net::HTTP).to have_received(:post).with(
        api_url,
        satisfy { |json| json_payload_contains_ref_and_rid(json) },
        {
          "Authorization" => "Bearer #{api_token}",
          "Content-Type" => "application/json",
        },
      )
    end

    def json_payload_contains_ref_and_rid(json)
      json.include? application_reference and json.include? upload_rid
    end
  end
end
