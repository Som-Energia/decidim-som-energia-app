# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = "0.26.5"

gem "codit-devise-cas-authenticable", git: "https://github.com/Som-Energia/codit-devise-cas-authenticable.git"
gem "decidim", DECIDIM_VERSION
gem "decidim-cas_client", git: "https://github.com/Som-Energia/decidim-cas-client.git"
gem "decidim-consultations", DECIDIM_VERSION
gem "decidim-initiatives", DECIDIM_VERSION

# A Decidim module to customize the localized terms in the system.
gem "decidim-term_customizer", github: "mainio/decidim-module-term_customizer", branch: "release/0.26-stable"

# Usability and UX tweaks for Decidim.
gem "decidim-action_delegator", github: "coopdevs/decidim-module-action_delegator", branch: "develop"
gem "decidim-decidim_awesome"
gem "decidim-reporting_proposals"

gem "bootsnap", "~> 1.7"
gem "deface"
gem "puma", ">= 5.3.1"

gem "wicked_pdf", "~> 2.1"

gem "progressbar"
gem "sentry-rails", "~> 5.3.1"
gem "sentry-ruby", "~> 5.3.1"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri
  gem "faker", "~> 2.14"

  gem "brakeman"
  gem "decidim-dev", DECIDIM_VERSION
end

group :development do
  gem "letter_opener_web"
  gem "listen", "~> 3.1"
  gem "rubocop-faker"
  gem "spring", ">= 4.0.0"
  gem "spring-watcher-listen", "~> 2.1"
  gem "web-console", "~> 4.2"
end

group :test do
  gem "rails-controller-testing"
end

group :production do
  gem "aws-sdk-s3", require: false
  gem "sidekiq", "~> 6.0"
  gem "sidekiq-cron", "~> 1.6.0"
end
