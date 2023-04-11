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
gem "decidim-action_delegator"
gem "decidim-decidim_awesome"
# gem "decidim-direct_verifications", "~> 1.0.2"

gem "bootsnap", "~> 1.7"

gem "puma", ">= 5.3.1"
gem "uglifier", "~> 4.1"

gem "faker", "~> 2.14"

gem "wicked_pdf", "~> 2.1"

gem "delayed_job_web"
gem "progressbar"
gem "sentry-rails", "~> 5.3.1"
gem "sentry-ruby", "~> 5.3.1"
gem "whenever", require: false

# bug in version 1.9
gem "i18n", "~> 1.8.1"
# bug in combination with truncato/nokogiri
gem "doc2text", "0.4.4"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "decidim-dev", DECIDIM_VERSION
end

group :development do
  gem "letter_opener_web", "~> 2.0"
  gem "listen", "~> 3.1"
  gem "rubocop-faker"
  gem "spring", ">= 4.0.0"
  gem "spring-watcher-listen", "~> 2.1"
  gem "web-console", "~> 4.2"

  gem "capistrano", "~> 3.15"
  gem "capistrano-bundler", "~> 2.0", require: false
  gem "capistrano-figaro-yml", "~> 1.0.2", require: false
  gem "capistrano-passenger", "~> 0.2.1", require: false
  gem "capistrano-rails", "~> 1.6", require: false
  gem "capistrano-rails-console", require: false
  gem "capistrano-rbenv", "~> 2.2", require: false
  gem "passenger", "~> 6.0"
end

group :production do
  gem "daemons", "~> 1.3"
  gem "delayed_job_active_record", "~> 4.1"
  gem "figaro", "~> 1.2"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
