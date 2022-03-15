require "net/http"

class TransferRecord
  def initialize; end

  def self.execute(record_id)
    IndividualExpressionOfInterest.transaction do
      application = IndividualExpressionOfInterest.find(record_id)
      application.transferred_at = Time.zone.now
      application.save!

      uri = URI(ENV["REMOTE_API_URL"])
      token = ENV["REMOTE_API_TOKEN"]
      res = Net::HTTP.post(uri, application.answers.to_json, "Content-Type" => "application/json", "Authorization" => "Bearer #{token}")
      unless res.code.to_i >= 200 && res.code.to_i < 300
        raise ActiveRecord::Rollback
      end
    end
  end
end
