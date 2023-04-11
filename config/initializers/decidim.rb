# frozen_string_literal: true

Decidim.configure do |config|
  config.application_name = "Participa Som Energia"

  config.mailer_sender = "participa@somenergia.coop"

  # Change these lines to set your preferred locales
  config.default_locale = :es
  config.available_locales = [:ca, :es, :eu, :gl]

  config.enable_html_header_snippets = true
  config.track_newsletter_links = true

  config.etherpad = {
    server: Rails.application.secrets.etherpad[:server],
    api_key: Rails.application.secrets.etherpad[:api_key],
    api_version: Rails.application.secrets.etherpad[:api_version]
  }
end

Rails.application.config.i18n.available_locales = Decidim.available_locales
Rails.application.config.i18n.default_locale = Decidim.default_locale

# Inform Decidim about the assets folder
Decidim.register_assets_path File.expand_path("app/packs", Rails.application.root)
