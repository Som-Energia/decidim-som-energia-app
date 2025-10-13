# frozen_string_literal: true

# This migration comes from decidim_sortitions (originally 20180104143054)
# This file has been modified by `decidim upgrade:migrations` task on 2025-10-13 08:59:11 UTC
class MakeSortitionReferenceNullable < ActiveRecord::Migration[5.1]
  def change
    change_column_null :decidim_module_sortitions_sortitions, :reference, true
  end
end
