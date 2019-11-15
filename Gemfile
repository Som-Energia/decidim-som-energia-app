source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = { git: 'https://github.com/decidim/decidim.git', branch: '0.19-stable' }

gem 'puma', '~> 3.0'
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
gem "decidim-cas_client", git: "ssh://git@gitlab.coditdev.net:534/decidim/decidim-cas-client.git", tag: "v0.0.20"
gem "codit-devise-cas-authenticable", git: "ssh://git@gitlab.coditdev.net:534/decidim/codit-devise-cas-authenticable.git", tag: "v0.0.6"

# A Decidim module to customize the localized terms in the system.
gem "decidim-term_customizer", git: "https://github.com/CodiTramuntana/decidim-module-term_customizer"

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
