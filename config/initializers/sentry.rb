Sentry.init do |config|
  config.breadcrumbs_logger = %i[active_support_logger http_logger]
  config.enabled_environments = %w[production staging]
  config.traces_sample_rate = 0.5
end
