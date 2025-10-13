# frozen_string_literal: true

# This migration comes from decidim (originally 20230409123300)
# This file has been modified by `decidim upgrade:migrations` task on 2025-10-13 08:59:10 UTC
class AddContentPolicyToDecidimOrganizations < ActiveRecord::Migration[6.1]
  def change
    add_column :decidim_organizations, :content_security_policy, :jsonb, default: {}
  end
end
