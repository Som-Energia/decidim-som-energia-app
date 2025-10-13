# frozen_string_literal: true

# This migration comes from decidim (originally 20170912082054)
# This file has been modified by `decidim upgrade:migrations` task on 2025-10-13 08:59:10 UTC
class AddEmailsOnNotificationsFlagToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_users, :email_on_notification, :boolean, default: false, null: false
  end
end
