class StorageService
  attr_reader :configuration

  def initialize(paas_config_service, paas_instance_name)
    @paas_config_service = paas_config_service
    @paas_instance_name = ("#{paas_instance_name}-s3" || "").to_sym
    @configuration = create_configuration
    @client = create_client
  end

  def write_file(file_name, data)
    Rails.logger.debug "Filename!"
    Rails.logger.debug file_name

    begin
      @client.put_object(
          body: data,
          bucket: @configuration.bucket_name,
          key: file_name,
          )
    rescue
      # Do nothing!
      Rails.logger.debug "Could NOT upload file!"
    end
  end

  private

  def create_configuration
    unless @paas_config_service.config_present?
      raise "No PaaS configuration present"
    end
    unless @paas_config_service.s3_buckets.key?(@paas_instance_name)
      raise "#{@paas_instance_name} instance name could not be found"
    end

    bucket_config = @paas_config_service.s3_buckets[@paas_instance_name]
    StorageConfiguration.new(bucket_config[:credentials])
  end

  def create_client
    Aws::S3::Client.new(
        region: @configuration.region,
        credentials: Aws::Credentials.new(
            @configuration.access_key_id,
            @configuration.secret_access_key,
            )
        )
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
