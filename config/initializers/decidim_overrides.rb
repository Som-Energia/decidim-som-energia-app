# frozen_string_literal: true

Decidim.menu :admin_user_menu do |menu|
  menu.add_item :cas_users,
                "Registra una usuaria socia", Rails.application.routes.url_helpers.new_admin_cas_user_path,
                active: is_active_link?(Rails.application.routes.url_helpers.new_admin_cas_user_path),
                if: allowed_to?(:read, :admin_user),
                position: 9
end

Rails.application.config.to_prepare do
  # participatory spaces private users
  Decidim::Devise::RegistrationsController.include(SomEnergia::Devise::RegistrationsControllerOverride)
  Decidim::Devise::SessionsController.include(SomEnergia::Devise::SessionsControllerOverride)
end
