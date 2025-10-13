# frozen_string_literal: true

# This migration comes from decidim (originally 20220127113419)
# This file has been modified by `decidim upgrade:migrations` task on 2025-10-13 08:59:10 UTC
class AddNotificationSettingsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :decidim_users, :notification_settings, :jsonb, default: {}
  end
end
