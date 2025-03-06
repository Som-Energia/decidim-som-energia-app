class RemoveUsernameAndExtraAttributes < ActiveRecord::Migration[6.1]
  def change
    Decidim::User.find_each do |user|
      user.extended_data ||= {}
      extra_attributes = user.extra_attributes || {}
      user.extended_data.merge!(extra_attributes)
      user.save!(validate: false)
    end
    remove_column :decidim_users, :username
    remove_column :decidim_users, :extra_attributes
  end
end
