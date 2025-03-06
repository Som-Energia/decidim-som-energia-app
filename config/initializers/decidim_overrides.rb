# frozen_string_literal: true

Decidim.menu :admin_menu do |menu|
  menu.add_item :custom_iframe,
                "Estadísques web",
                Rails.application.routes.url_helpers.admin_iframe_index_path,
                icon_name: "pie-chart",
                position: 10,
                if: ENV.fetch("ADMIN_IFRAME_URL", nil).present?
end

Decidim.menu :admin_user_menu do |menu|
  menu.add_item :cas_users,
                "Registra una usuaria socia", Rails.application.routes.url_helpers.new_admin_cas_user_path,
                active: is_active_link?(Rails.application.routes.url_helpers.new_admin_cas_user_path),
                if: allowed_to?(:read, :admin_user),
                position: 9
end

Rails.application.config.to_prepare do
  # participatory spaces private users
  Decidim::Admin::ParticipatorySpacePrivateUserForm.include(SomEnergia::Admin::ParticipatorySpacePrivateUserFormOverride)
  Decidim::Admin::ParticipatorySpacePrivateUserCsvImportForm.include(SomEnergia::Admin::ParticipatorySpacePrivateUserCsvImportFormOverride)
  Decidim::Admin::ProcessParticipatorySpacePrivateUserImportCsv.include(SomEnergia::Admin::ProcessParticipatorySpacePrivateUserImportCsvOverride)
  Decidim::Admin::CreateParticipatorySpacePrivateUser.include(SomEnergia::Admin::CreateParticipatorySpacePrivateUserOverride)
  Decidim::Admin::ImportParticipatorySpacePrivateUserCsvJob.include(SomEnergia::Admin::ImportParticipatorySpacePrivateUserCsvJobOverride)
  Decidim::Devise::InvitationsController.include(SomEnergia::Devise::InvitationsControllerOverride)
  Decidim::Devise::RegistrationsController.include(SomEnergia::Devise::RegistrationsControllerOverride)
  Decidim::Assemblies::Admin::ParticipatorySpacePrivateUsersCsvImportsController.include(SomEnergia::Admin::HasPrivateUsersCsvImportOverride)
  Decidim::ParticipatoryProcesses::Admin::ParticipatorySpacePrivateUsersCsvImportsController.include(SomEnergia::Admin::HasPrivateUsersCsvImportOverride)
end
