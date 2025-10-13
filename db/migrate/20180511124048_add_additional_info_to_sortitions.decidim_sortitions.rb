# frozen_string_literal: true

# This migration comes from decidim_sortitions (originally 20171220164744)
# This file has been modified by `decidim upgrade:migrations` task on 2025-10-13 08:59:11 UTC
class AddAdditionalInfoToSortitions < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_module_sortitions_sortitions, :additional_info, :jsonb
  end
end
