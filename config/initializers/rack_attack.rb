if Rails.env.development? || Rails.env.test?
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
  Rack::Attack.enabled = false
else
  Rails.application.config.to_prepare do
    redis_url = PaasConfigurationService.new.redis_uris[:"ukraine-sponsor-resettlement-#{Rails.env}-redis"]
    Rack::Attack.cache.store = ActiveSupport::Cache::RedisCacheStore.new(url: redis_url)
  end
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
