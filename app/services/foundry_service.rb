require "net/http"
require "json"

class FoundryService
  def initialize(api_uri = nil, api_token = nil)
    @uri = api_uri || URI(ENV["REMOTE_API_URL"]) # UAM_FOUNDRY_ATTACHMENT_ASSIGN_API_URL
    @token = api_token || ENV["REMOTE_API_TOKEN_UAM"] # UAM_FILE_UPLOAD_API_TOKEN
  end

  def assign_uploaded_uk_consent_form(uam_reference, rid)
    payload = self.class.json_payload("uk", uam_reference, rid)
    assign_uploaded_consent_form(payload)
  end

  def assign_uploaded_ukraine_consent_form(uam_reference, rid)
    payload = self.class.json_payload("ukraine", uam_reference, rid)
    assign_uploaded_consent_form(payload)
  end

  def self.json_payload(type, uam_reference, rid)
    JSON.generate(
      {
        parameters:
        {
          type: "unaccompanied_minor_attachment_#{type}_consent",
          created_at: Time.zone.now.utc.strftime("%F %T"),
          form_reference: uam_reference,
          rid:,
        },
      },
    )
  end

private

  def assign_uploaded_consent_form(json)
    res = Net::HTTP.post(@uri, json,
                         "Content-Type" => "application/json",
                         "Authorization" => "Bearer #{@token}")

    unless res.code.to_i >= 200 && res.code.to_i < 300
      message = "Failed post to assign consent form. res.code:#{res.code} JSON:#{json}"

      Rails.logger.error message
      raise message
    end
  end
end
