require "rails_helper"

RSpec.describe FoundryService do
  it "generates the correct json parameters" do
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

    expect(described_class.json_params("uk", "SPON-1234-42EC-Z", "some-rid-value"))
    .to eq(expected_json)
  end
end
