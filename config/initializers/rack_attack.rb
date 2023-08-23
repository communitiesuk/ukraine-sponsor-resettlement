require "paas_configuration_service"

if Rails.env.development? || Rails.env.test?
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
  Rack::Attack.enabled = false
else
  redis_url = PaasConfigurationService.new.redis_uris[:"ukraine-sponsor-resettlement-#{Rails.env}-redis"]
  Rack::Attack.cache.store = ActiveSupport::Cache::RedisCacheStore.new(
    url: redis_url,
    connect_timeout: 60,  # Defaults to 20 seconds
    read_timeout: 5, # Defaults to 1 second
    write_timeout: 5, # Defaults to 1 second
    reconnect_attempts: 1,   # Defaults to 0
  )
end

Rack::Attack.throttle("requests by ip", limit: 60, period: 60.seconds) do |request|
  request.ip unless request.path == "/429"
end

Rack::Attack.throttled_responder = lambda do |_env|
  headers = {
    "Location" => "/429",
  }
  [301, headers, []]
end
