require "paas_configuration_service"

if Rails.env.development? || Rails.env.test?
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
  Rack::Attack.enabled = false
else
  redis_url = PaasConfigurationService.new.redis_uris[:"ukraine-sponsor-resettlement-#{Rails.env}-redis"]
  Rack::Attack.cache.store = ActiveSupport::Cache::RedisCacheStore.new(url: redis_url)
end

if Rails.env.staging?
  Rack::Attack.safelist("allow cypress e2e via UA") do |req|
    req.user_agent.to_s.include?(ENV.fetch("CYPRESS_UA_TAG", "CYPRESS-E2E"))
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
