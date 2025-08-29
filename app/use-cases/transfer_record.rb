require "net/http"

class TransferRecord
  def initialize; end

  def self.execute_expression_of_interest(record_id)
    ExpressionOfInterest.transaction do
      application = ExpressionOfInterest.find(record_id)
      application.transferred_at = Time.zone.now
      application.save!

      uri = URI(ENV["REMOTE_API_URL_EOI"])
      token = ENV["REMOTE_API_TOKEN"]
      res = Net::HTTP.post(uri, JSON.generate(application.as_json), "Content-Type" => "application/json", "Authorization" => "Bearer #{token}")
      if res.code.to_i >= 200 && res.code.to_i < 300
        Rails.logger.debug("[TransferRecord] EOI to #{uri} [#{res.code}: #{res.message}]")
      else
        Rails.logger.error "Failed to post record: #{record_id} to: #{uri} res.code: #{res.code} | res.message: #{res.message}"
        raise ActiveRecord::Rollback
      end
    end
  end

  def self.execute_unaccompanied_minor(record_id)
    UnaccompaniedMinor.transaction do
      application = UnaccompaniedMinor.find(record_id)
      json = application.prepare_transfer
      uri = URI(ENV["REMOTE_API_URL_UAM"])
      token = ENV["REMOTE_API_TOKEN_UAM"]

      post(uri, json, token, record_id)
    end
  end

  def self.post(uri, json, bearer_token, record_id)
    res = Net::HTTP.post(uri, json, "Content-Type" => "application/json", "Authorization" => "Bearer #{bearer_token}")

    if res.code.to_i >= 200 && res.code.to_i < 300
      Rails.logger.debug("[TransferRecord] UAM to #{uri} [#{res.code}: #{res.message}]")
    else
      Rails.logger.error "Failed to post record: #{record_id} to: #{uri} res.code: #{res.code} | res.message: #{res.message}"
      raise ActiveRecord::Rollback
    end
    res
  end
end
