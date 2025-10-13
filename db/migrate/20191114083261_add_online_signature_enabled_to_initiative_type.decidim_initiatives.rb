# frozen_string_literal: true

# This migration comes from decidim_initiatives (originally 20181212155125)
# This file has been modified by `decidim upgrade:migrations` task on 2025-10-13 08:59:10 UTC
class AddOnlineSignatureEnabledToInitiativeType < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_initiatives_types, :online_signature_enabled, :boolean, null: false, default: true
  end
end
