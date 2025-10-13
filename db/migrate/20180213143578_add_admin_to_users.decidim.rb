# frozen_string_literal: true

# This migration comes from decidim (originally 20170713131206)
# This file has been modified by `decidim upgrade:migrations` task on 2025-10-13 08:59:10 UTC
class AddAdminToUsers < ActiveRecord::Migration[5.1]
  def up
    add_column :decidim_users, :admin, :boolean, null: false, default: false

    execute <<~SQL.squish
      UPDATE decidim_users
      SET admin = true
      WHERE roles @> '{admin}'
    SQL
  end
end
