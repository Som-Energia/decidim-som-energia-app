# frozen_string_literal: true
# This migration comes from decidim_cas_client (originally 20180321160833)

class AddUsernameToDecidimUser < ActiveRecord::Migration[5.1]
  def up
    raise "Decidim::User table does not exists" unless ActiveRecord::Base.connection.table_exists? "decidim_users"
    add_column :decidim_users, :username, :string unless column_exists?(:decidim_users, :username)
    add_column :decidim_users, :extra_attributes, :jsonb unless column_exists?(:decidim_users, :extra_attributes)
    add_index :decidim_users, :username unless index_exists?(:decidim_users, :username)

    # For CAS users, email + organization index must not be unique
    if index_exists?(:decidim_users, %w(email decidim_organization_id))
      remove_index :decidim_users, %w(email decidim_organization_id)
      add_index :decidim_users,
                %w(email decidim_organization_id),
                where: "(deleted_at IS NULL) AND (managed = 'f')",
                name: "index_decidim_users_on_email_and_decidim_organization_id",
                unique: false
    end
  end

  def down
    remove_index :decidim_users, :username if index_exists?(:decidim_users, :username)
    remove_column :decidim_users, :username if column_exists?(:decidim_users, :username)
    remove_column :decidim_users, :extra_attributes if column_exists?(:decidim_users, :extra_attributes)

    # Restore index configuration
    if index_exists?(:decidim_users, %w(email decidim_organization_id))
      remove_index :decidim_users, %w(email decidim_organization_id)
      add_index :decidim_users,
                %w(email decidim_organization_id),
                where: "(deleted_at IS NULL) AND (managed = 'f')",
                name: "index_decidim_users_on_email_and_decidim_organization_id",
                unique: true

    end
  end
end
