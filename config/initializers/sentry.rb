Sentry.init do |config|
  config.breadcrumbs_logger = %i[active_support_logger http_logger]
  config.enabled_environments = %w[production staging]

  # release versioning
  instance_name = ENV.fetch("INSTANCE_NAME")
  app_latest_version = `git rev-parse HEAD`.chomp! "\n"
  config.release = "#{instance_name}@#{app_latest_version}"

  config.traces_sampler = lambda do |sampling_context|
    # if this is the continuation of a trace, just use that decision (rate controlled by the caller)
    unless sampling_context[:parent_sampled].nil?
      next sampling_context[:parent_sampled]
    end

    transaction_context = sampling_context[:transaction_context]

    op = transaction_context[:op]
    transaction_name = transaction_context[:name]

    case op
    when /request/
      # for Rails applications, transaction_name would be the request's path (env["PATH_INFO"]) instead of "Controller#action"
      case transaction_name
      when /health/
        0.0
      else
        0.1
      end
    when /sidekiq/
      0.01
    else
      0.0
    end
  end
end
