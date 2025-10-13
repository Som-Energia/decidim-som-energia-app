# frozen_string_literal: true

# This migration comes from decidim_initiatives (originally 20220518053612)
# This file has been modified by `decidim upgrade:migrations` task on 2025-10-13 08:59:10 UTC
class AddCommentsEnabledToInitiativeTypes < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_initiatives_types, :comments_enabled, :boolean, null: false, default: true
  end
end
