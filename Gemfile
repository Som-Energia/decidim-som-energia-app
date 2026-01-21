# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = { github: "decidim/decidim", branch: "release/0.31-stable" }.freeze

gem "decidim", DECIDIM_VERSION
gem "decidim-initiatives", DECIDIM_VERSION
gem "decidim-templates", DECIDIM_VERSION
gem "decidim-verifications", DECIDIM_VERSION

# A Decidim module to customize the localized terms in the system.
gem "decidim-term_customizer", github: "openpoke/decidim-module-term_customizer", branch: "release/0.31-stable"

# Usability and UX tweaks for Decidim.
# gem "decidim-action_delegator", github: "coopdevs/decidim-module-action_delegator"
gem "decidim-decidim_awesome", github: "decidim-ice/decidim-module-decidim_awesome", branch: "release/0.31-stable"
gem "decidim-pokecode", github: "openpoke/decidim-module-pokecode", branch: "main"

gem "bootsnap", "~> 1.7"
gem "omniauth-cas"
gem "progressbar"
gem "puma"

group :development, :test do
  gem "byebug", platform: :mri

  gem "brakeman"
  gem "decidim-dev", DECIDIM_VERSION
end

group :development do
  gem "letter_opener_web"
  gem "listen"
  gem "web-console"
end
