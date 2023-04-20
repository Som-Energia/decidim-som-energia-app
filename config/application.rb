# frozen_string_literal: true

require_relative "boot"

# Add the frameworks used by your app that are not loaded by Decidim.
# require "rails/all"
require "decidim/rails"
require "action_cable/engine"
require "rails/test_unit/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require_relative "../app/middleware/assemblies_scoper"
require_relative "../app/middleware/participatory_processes_scoper"
require_relative "../lib/decidim/env"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Decidim
  def self.module_installed?(mod)
    Gem.loaded_specs.has_key?("decidim-#{mod}")
  end
end

module DecidimSomenergiaApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # this middleware will detect by the URL if all calls to Assembly need to skip (or include) certain types
    # this is done here to be sure it is run after the Decidim gem own initializers
    # initializer :scopers do |app|
    #   # app.config.middleware.insert_after Decidim::StripXForwardedHost, AssembliesScoper
    #   app.config.middleware.insert_after AssembliesScoper, ParticipatoryProcessesScoper
    #   # this avoid to trap the error trace when debugging errors
    #   Rails.backtrace_cleaner.add_silencer { |line| line =~ %r{app/middleware} }
    # end

    # load Overrides
    config.autoload_paths << Rails.root.join("app/lib")
  end
end
