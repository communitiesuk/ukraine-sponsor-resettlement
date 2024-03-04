class StorageService
  attr_reader :configuration

  def initialize(config_service, instance_name)
    @config_service = config_service
    @instance_name = "#{instance_name}-s3".to_sym
    @configuration = create_configuration
    @client = create_client
  end

  def write_file(file_name, data)
    @client.put_object(
      body: data,
      bucket: @configuration.bucket_name,
      key: file_name,
    )
  rescue StandardError => e
    Rails.logger.error "Could not upload file #{file_name}, #{e.message}"
  end

  def download(object_key)
    file_target = "/tmp/#{object_key}"

    resp = @client.get_object(
      response_target: file_target,
      bucket: @configuration.bucket_name,
      key: object_key,
    )

    Rails.logger.debug "****************************************************************"
    Rails.logger.debug "Download response: #{resp.to_h}"
    Rails.logger.debug "****************************************************************"

    file_target
  end

private

  def create_configuration
    unless @config_service.config_present?
      raise "No PaaS configuration present"
    end
    unless @config_service.s3_buckets.key?(@instance_name)
      raise "#{@instance_name} instance name could not be found"
    end

    bucket_config = @config_service.s3_buckets[@instance_name]
    StorageConfiguration.new(bucket_config[:credentials])
  end

  def create_client
    if Rails.env.development? || Rails.env.test?
      Aws::S3::Client.new(
        endpoint: "http://127.0.0.1:4566",
        region: @configuration.region,
        credentials: Aws::Credentials.new(
          @configuration.access_key_id,
          @configuration.secret_access_key,
        ),
        force_path_style: true,
      )
    else
      Aws::S3::Client.new(
        region: @configuration.region,
        credentials: Aws::Credentials.new(
          @configuration.access_key_id,
          @configuration.secret_access_key,
        ),
      )
    end
  end
end

class StorageConfiguration
  attr_reader :access_key_id, :secret_access_key, :bucket_name, :region

  def initialize(credentials)
    @access_key_id = credentials[:aws_access_key_id]
    @secret_access_key = credentials[:aws_secret_access_key]
    @bucket_name = credentials[:bucket_name]
    @region = credentials[:aws_region]
  end

  def ==(other)
    @access_key_id == other.access_key_id &&
      @secret_access_key == other.secret_access_key &&
      @bucket_name == other.bucket_name &&
      @region == other.region
  end
end
