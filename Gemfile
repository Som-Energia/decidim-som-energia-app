# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = { github: "decidim/decidim", branch: "release/0.27-stable" }.freeze

gem "codit-devise-cas-authenticable", github: "Som-Energia/codit-devise-cas-authenticable"
gem "decidim", DECIDIM_VERSION
gem "decidim-cas_client", github: "Som-Energia/decidim-cas-client"
gem "decidim-consultations", DECIDIM_VERSION
gem "decidim-initiatives", DECIDIM_VERSION
gem "decidim-templates", DECIDIM_VERSION

# A Decidim module to customize the localized terms in the system.
gem "decidim-term_customizer", github: "mainio/decidim-module-term_customizer", branch: "master"

# Usability and UX tweaks for Decidim.
gem "decidim-action_delegator", github: "coopdevs/decidim-module-action_delegator"
gem "decidim-decidim_awesome", github: "decidim-ice/decidim-module-decidim_awesome"
gem "decidim-reporting_proposals", github: "openpoke/decidim-module-reporting-proposals"

gem "bootsnap", "~> 1.7"
gem "deface"
gem "puma", ">= 5.3.1"

gem "wicked_pdf", "~> 2.1"

gem "progressbar"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri
  gem "faker"

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
  gem "sidekiq"
  gem "sidekiq-cron"
end
