# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"

Rails.application.load_tasks

task :test_app do
  # Seems migrations are failing due to `decidim-cas_client` gem requiring the
  # user table via devise in the routes. https://stackoverflow.com/a/35844553
  ENV["RAILS_ENV"] = "test"
  system("bundle exec rake decidim:generate_external_test_app")
  system("bundle exec rake db:create db:schema:load")
end
