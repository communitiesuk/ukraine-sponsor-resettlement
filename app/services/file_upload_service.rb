require "net/http"

class FileUploadService
  def initialize(api_uri = nil, api_token = nil)
    @uri = api_uri || ENV["UAM_FILE_UPLOAD_API_URL"]
    @token = api_token || ENV["UAM_FILE_UPLOAD_API_TOKEN"]
  end

  def upload(file_path, file_name)
    # Account needed to view docs.
    # https://levellingup.palantirfoundry.co.uk/workspace/documentation/product/api-gateway/upload-attachment

    file_data = get_file_data(file_path)
    uri = uri_for(file_name)
    res = post(uri, file_data)

    Rails.logger.debug(res.body)
    results = JSON.parse(res.body)
    results["rid"]
  end

  def post(uri, file_data)
    res = Net::HTTP.post(uri,
                         file_data,
                         "Content-Type" => "application/octet-stream",
                         "Authorization" => "Bearer #{@token}")

    unless res.code.to_i >= 200 && res.code.to_i < 300
      Rails.logger.error "Failed to post file to: #{uri} res.code: #{res.code}"
      raise "Failed to post file to foundry"
    end
    res
  end

  def uri_for(file_name)
    uri = URI(@uri)
    uri.query = "filename=#{file_name}"
    uri
  end

private

  def get_file_data(file_path)
    begin
      file_data = File.binread(file_path)
    rescue StandardError => e
      Rails.logger.error "Failed to load file #{file_path}: #{e.message}"
      raise e
    end
    file_data
  end
end
