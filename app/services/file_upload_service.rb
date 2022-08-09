require "net/http"

class FileUploadService
  def upload(file_path, file_name)
    # Account needed to view docs.
    # https://levellingup.palantirfoundry.co.uk/workspace/documentation/product/api-gateway/upload-attachment

    token = ENV["UAM_FILE_UPLOAD_API_TOKEN"]

    uri = URI(ENV["UAM_FILE_UPLOAD_API_URL"])
    uri.query = "filename=#{file_name}"

    file_data = File.binread(file_path)

    res = Net::HTTP.post(uri,
                         file_data,
                         "Content-Type" => "application/octet-stream",
                         "Authorization" => "Bearer #{token}")

    unless res.code.to_i >= 200 && res.code.to_i < 300
      Rails.logger.error "Failed to post file: #{file_name} to: #{uri} res.code: #{res.code}"
      raise "Failed to post file to foundry"
    end

    results = JSON.parse(res.body)
    results[rid]
  end
end
