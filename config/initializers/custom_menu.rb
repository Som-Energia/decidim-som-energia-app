# frozen_string_literal: true

Decidim.menu :menu do |menu|
  if Rails.application.secrets.menu[current_organization.host.to_sym].respond_to? :each
    Rails.application.secrets.menu[current_organization.host.to_sym].each do |item|
      options = {}
      options[:position] = item[:position].to_i if item[:position]
      options[:active] = item[:active].to_sym if item[:active]
      options[:icon_name] = item[:icon_name].to_s if item[:icon_name]
      if item[:if_membership_in]
        assembly = Decidim::Assembly.find_by(slug: item[:if_membership_in])
        options[:if] = assembly ? assembly.participatory_space_private_users.where(decidim_user_id: current_user).any? : false
      end
      menu.item I18n.t(item[:key]), item[:url], options
    end
  end
end
