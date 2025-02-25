HealthCheck.setup do |config|
  config.standard_checks -= ["emailconf"]
end
