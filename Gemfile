source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = { git: 'https://github.com/decidim/decidim.git', branch: '0.19-stable' }

#gem 'puma', '~> 4.0'
gem 'uglifier', '>= 1.3.0'
gem 'delayed_job_active_record'
gem 'daemons'
gem 'whenever'

gem 'figaro', '>= 1.1.1'

# Force gem version to fix (prevent to being upgraded to 2.3):
# undefined method `polymorphic?' for ActiveRecord::Reflection::PolymorphicReflection
# See: https://github.com/activerecord-hackery/ransack/issues/1039
gem 'ransack', '~> 2.1.1'

gem 'decidim', DECIDIM_VERSION
gem 'decidim-consultations', DECIDIM_VERSION
gem 'decidim-initiatives'
gem "decidim-cas_client", git: "git@github.com:CodiTramuntana/decidim-cas-client.git", tag: "v0.0.20"
gem "codit-devise-cas-authenticable", git: "ssh://git@gitlab.coditdev.net:534/decidim/codit-devise-cas-authenticable.git", tag: "v0.0.6"

# A Decidim module to customize the localized terms in the system.
gem "decidim-term_customizer", git: "https://github.com/mainio/decidim-module-term_customizer"
# Compability with decidim initiatives module
gem 'wicked_pdf'

# Security fixes:
# actionview: GHSA-65cv-r6x7-79hv
gem "rails", ">= 5.2.4.2"
# gem "actionview", ">= 5.2.4.2"
# nokogiri: CVE-2020-7595
gem "nokogiri", ">= 1.10.8"
# puma: GHSA-33vf-4xgg-9r58
gem "puma", ">= 3.12.4"
# rack-cors: CVE-2019-18978
gem "rack-cors", ">= 1.0.4"
# loofah: CVE-2019-15587
gem "loofah", ">= 2.3.1"
# rubyzip: CVE-2019-16892
gem "rubyzip", ">= 1.3.0"
# devise: CVE-2019-16109
gem "devise", ">= 4.7.1"
# mini_magick: CVE-2019-13574
gem "mini_magick", ">= 4.9.4"

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'faker', "~> 1.8.4"
end

group :development do
  gem 'decidim-dev', DECIDIM_VERSION
  gem 'web-console'
  gem 'listen', '~> 3.1.0'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'letter_opener_web', '~> 1.3.0'
end


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
