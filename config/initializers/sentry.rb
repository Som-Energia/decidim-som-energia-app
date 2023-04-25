# frozen_string_literal: true

Sentry.init do |config|
  config.dsn = "https://1dac66ab76244970812d185efdb9aeeb@o279313.ingest.sentry.io/5699904"
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  config.traces_sample_rate = 0.5
end
