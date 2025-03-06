class RestoreEmailUniqueness < ActiveRecord::Migration[6.1]
  def up
    if index_exists?(:decidim_users, %w(email decidim_organization_id))
      remove_index :decidim_users, %w(email decidim_organization_id)
      add_index :decidim_users,
                %w(email decidim_organization_id),
                where: "(deleted_at IS NULL) AND (managed = 'f')",
                name: "index_decidim_users_on_email_and_decidim_organization_id",
                unique: true

    end
  end

  def down
    remove_index :decidim_users, %w(email decidim_organization_id)
    add_index :decidim_users,
              %w(email decidim_organization_id),
              where: "(deleted_at IS NULL) AND (managed = 'f')",
              name: "index_decidim_users_on_email_and_decidim_organization_id",
              unique: false
  end
end
