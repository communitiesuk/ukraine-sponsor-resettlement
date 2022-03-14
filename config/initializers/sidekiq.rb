Sidekiq.configure_client do |config|
  redis_uri = PaasConfigurationService.new.redis_uris[:"ukraine-sponsor-resettlement-#{Rails.env}-redis"]
  config.redis = { url: redis_uri }
end

Sidekiq.configure_server do |config|
  redis_uri = PaasConfigurationService.new.redis_uris[:"ukraine-sponsor-resettlement-#{Rails.env}-redis"]
  config.redis = { url: redis_uri }
end
