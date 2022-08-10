require "net/http"
require "json"

class FoundryService
  def assign_uploaded_uk_consent_form(uam_reference, rid)
    uri = URI(ENV["REMOTE_API_URL"])
    token = ENV["REMOTE_API_TOKEN_UAM"]

    params = {
      type: "unaccompanied_minor_attachment_uk_consent",
      created_at: Time.zone.now.utc.strftime("%F %T"),
      form_reference: uam_reference,
      rid:,
    }

    res = Net::HTTP.post(uri, params.to_json,
                         "Content-Type" => "application/json",
                         "Authorization" => "Bearer #{token}")

    unless res.code.to_i >= 200 && res.code.to_i < 300
      message = "Failed to post to assign rid: #{rid} to uam: #{uam_reference} to: #{uri} res.code: #{res.code}"

      Rails.logger.error message
      raise message
    end
  end

  def assign_uploaded_ukraine_consent_form(uam_reference, rid)
    uri = URI(ENV["REMOTE_API_URL"])
    token = ENV["REMOTE_API_TOKEN_UAM"]

    params = {
      type: "unaccompanied_minor_attachment_ukraine_consent",
      created_at: Time.zone.now.utc.strftime("%F %T"),
      form_reference: uam_reference,
      rid:,
    }

    res = Net::HTTP.post(uri, params.to_json,
                         "Content-Type" => "application/json",
                         "Authorization" => "Bearer #{token}")

    unless res.code.to_i >= 200 && res.code.to_i < 300
      message = "Failed to post to assign rid: #{rid} to uam: #{uam_reference} to: #{uri} res.code: #{res.code}"

      Rails.logger.error message
      raise message
    end
  end
end
