# frozen_string_literal: true

# This migration comes from decidim_sortitions (originally 20180103160301)
# This file has been modified by `decidim upgrade:migrations` task on 2025-10-13 08:59:11 UTC
class AddCancelDataToSortition < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_module_sortitions_sortitions, :cancel_reason, :jsonb
    add_column :decidim_module_sortitions_sortitions, :cancelled_on, :datetime
    add_column :decidim_module_sortitions_sortitions, :cancelled_by_user_id, :integer, index: true
  end
end
