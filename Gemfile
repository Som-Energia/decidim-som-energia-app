# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = { github: "openpoke/decidim", branch: "0.27-backports" }.freeze

gem "codit-devise-cas-authenticable", github: "Som-Energia/codit-devise-cas-authenticable"
gem "decidim", DECIDIM_VERSION
gem "decidim-cas_client", github: "Som-Energia/decidim-cas-client"
gem "decidim-consultations", DECIDIM_VERSION
gem "decidim-initiatives", DECIDIM_VERSION
gem "decidim-templates", DECIDIM_VERSION

# A Decidim module to customize the localized terms in the system.
gem "decidim-term_customizer", github: "mainio/decidim-module-term_customizer", branch: "release/0.27-stable"

# Usability and UX tweaks for Decidim.
gem "decidim-action_delegator", github: "coopdevs/decidim-module-action_delegator"
gem "decidim-decidim_awesome", github: "decidim-ice/decidim-module-decidim_awesome", branch: "release/0.27-stable"
gem "decidim-reporting_proposals", "~> 0.5.2"

# https://stackoverflow.com/questions/79360526/uninitialized-constant-activesupportloggerthreadsafelevellogger-nameerror
gem "bootsnap", "~> 1.7"
gem "deface"
gem "puma"

gem "progressbar"
gem "wicked_pdf"

group :development, :test do
  gem "byebug", platform: :mri
  gem "faker"
  gem "rubocop-faker"

  gem "brakeman"
  gem "decidim-dev", DECIDIM_VERSION
end

group :development do
  gem "letter_opener_web"
  gem "listen"
  gem "spring"
  gem "spring-watcher-listen"
  gem "web-console"
end

group :test do
  gem "rails-controller-testing"
end

group :production do
  gem "aws-sdk-s3", require: false
  gem "sidekiq"
  gem "sidekiq-cron"
end
