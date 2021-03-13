class AddCasUserToParticipatorySpacePrivateUser < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_participatory_space_private_users, :cas_user, :boolean, default: false, null: false
  end
end
