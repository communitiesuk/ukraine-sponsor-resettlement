require "rails_helper"

RSpec.describe "TransferRecord executing minors" do
  before do
    ENV["REMOTE_API_URL_UAM"] = ENV["REMOTE_API_URL_UAM"] || "https://example.com/api"
    ENV["REMOTE_API_TOKEN_UAM"] = ENV["REMOTE_API_TOKEN_UAM"] || "some_api_token"
  end

  describe "execute_unaccompanied_minor !" do
    let(:remote_api_token_api) { ENV["REMOTE_API_TOKEN_UAM"] }
    let(:remote_api_url) { ENV["REMOTE_API_URL_UAM"] }
    let(:uam) { instance_double(UnaccompaniedMinor) }
    let(:json_payload) { "{\"reference\":\"SPON-EDE1-4065-B\"}" }
    let(:response) { Net::HTTPResponse.new(1.0, 200, "OK") }

    before do
      allow(UnaccompaniedMinor).to receive(:find).and_return(uam)
      allow(uam).to receive(:prepare_transfer).with(no_args).and_return(json_payload)
      allow(Net::HTTP).to receive(:post).and_return(response)
    end

    it "calls prepare_transfer on the uam and posts the returned data" do
      TransferRecord.execute_unaccompanied_minor(1)

      expect(uam).to have_received(:prepare_transfer).with(no_args)

      expect(Net::HTTP).to have_received(:post).with(
        URI(remote_api_url),
        json_payload,
        {
          "Authorization" => "Bearer #{remote_api_token_api}",
          "Content-Type" => "application/json",
        },
      )
    end
  end
end
