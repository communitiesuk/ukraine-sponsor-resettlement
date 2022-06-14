class PaasConfigurationService
  attr_reader :s3_buckets, :redis_uris, :paas_config

  def initialize(logger = Rails.logger)
    @logger = logger
    @paas_config = read_paas_config
    @s3_buckets = read_s3_buckets
    @redis_uris = read_redis_uris
  end

  def config_present?
    !ENV["VCAP_SERVICES"].nil?
  end

  def redis_config_present?
    config_present? && @paas_config.key?(:redis)
  end

  def s3_config_present?
    config_present? && @paas_config.key?(:"aws-s3-bucket")
  end

private

  def read_paas_config
    unless config_present?
      @logger.warn("Could not find VCAP_SERVICES in the environment!")
      return {}
    end

    begin
      JSON.parse(ENV["VCAP_SERVICES"], { symbolize_names: true })
    rescue StandardError
      @logger.warn("Could not parse VCAP_SERVICES!")
      {}
    end
  end

  def read_redis_uris
    return {} unless redis_config_present?

    redis_uris = {}
    @paas_config[:redis].each do |redis_config|
      if redis_config.key?(:instance_name)
        redis_uris[redis_config[:instance_name].to_sym] = redis_config.dig(:credentials, :uri)
      end
    end
    redis_uris
  end

  def read_s3_buckets
    return {} unless s3_config_present?

    s3_buckets = {}
    @paas_config[:"aws-s3-bucket"].each do |bucket_config|
      if bucket_config.key?(:instance_name)
        s3_buckets[bucket_config[:instance_name].to_sym] = bucket_config
      end
    end
    s3_buckets
  end
end
