require "rails_helper"

RSpec.describe FoundryService do
  fit "generates the correct json parameters" do
    time_now = Time.zone.local(1970, 1, 1)
    allow(Time).to receive(:now).and_return(time_now)

    expected_json = {
      parameters: {
        type: "unaccompanied_minor_attachment_uk_consent",
        created_at: time_now.utc.strftime("%F %T"),
        form_reference: "SPON-1234-42EC-Z",
        rid: "some-rid-value",
      },
    }.to_json

    expect(described_class.json_payload("uk", "SPON-1234-42EC-Z", "some-rid-value"))
    .to eq(expected_json)
  end

  fit "posts to foundry to link the uk consent form" do
    time_now = Time.zone.local(1970, 1, 1)
    allow(Time).to receive(:now).and_return(time_now)

    resp = Net::HTTPResponse.new(1.0, 200, "OK")
    allow(Net::HTTP).to receive(:post).and_return(resp)

    x = described_class.new("https://example.com/api", "mytoken")
    x.assign_uploaded_uk_consent_form("my_reference", "my_rid")

    expect(Net::HTTP).to have_received(:post).with("https://example.com/api",
                                                   "{\"parameters\":{\"type\":\"unaccompanied_minor_attachment_uk_consent\",\"created_at\":\"1970-01-01 00:00:00\",\"form_reference\":\"my_reference\",\"rid\":\"my_rid\"}}",
                                                   { "Authorization" => "Bearer mytoken", "Content-Type" => "application/json" })
  end
end
