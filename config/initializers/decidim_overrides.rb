# frozen_string_literal: true

# extra menus defined in secrets.yml
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
      menu.add_item item[:key], I18n.t(item[:key]), item[:url], options
    end
  end
end

Decidim.menu :admin_menu do |menu|
  menu.add_item :custom_iframe,
                "Estadísques web",
                Rails.application.routes.url_helpers.admin_iframe_index_path,
                icon_name: "pie-chart",
                position: 10,
                if: ENV.fetch("#{current_organization.host.split(".").first.upcase}_ANALYTICS_URL", nil).present?
end

Decidim.menu :admin_user_menu do |menu|
  menu.add_item :cas_users,
                "Registra una usuaria socia", Rails.application.routes.url_helpers.new_admin_cas_user_path,
                active: is_active_link?(Rails.application.routes.url_helpers.new_admin_cas_user_path),
                if: allowed_to?(:read, :admin_user),
                position: 9
end

# this middleware will detect by the URL if all calls to Assembly need to skip (or include) certain types
Rails.configuration.middleware.use AssembliesScoper
Rails.configuration.middleware.use ParticipatoryProcessesScoper

Rails.application.config.to_prepare do
  # participatory spaces private users
  Decidim::Admin::ParticipatorySpacePrivateUserForm.include(SomEnergia::Admin::ParticipatorySpacePrivateUserFormOverride)
  Decidim::Admin::ParticipatorySpacePrivateUserCsvImportForm.include(SomEnergia::Admin::ParticipatorySpacePrivateUserCsvImportFormOverride)
  Decidim::Admin::ProcessParticipatorySpacePrivateUserImportCsv.include(SomEnergia::Admin::ProcessParticipatorySpacePrivateUserImportCsvOverride)
  Decidim::Admin::CreateParticipatorySpacePrivateUser.include(SomEnergia::Admin::CreateParticipatorySpacePrivateUserOverride)
  Decidim::Admin::ImportParticipatorySpacePrivateUserCsvJob.include(SomEnergia::Admin::ImportParticipatorySpacePrivateUserCsvJobOverride)
  Decidim::Consultations::ConsultationSearch.include(SomEnergia::Consultations::ConsultationSearchOverride)
  Decidim::Consultations::ConsultationsController.include(SomEnergia::Consultations::ConsultationsControllerOverride)
  Decidim::Consultations::ConsultationsHelper.include(SomEnergia::Consultations::ConsultationsHelperOverride)
  Decidim::Devise::InvitationsController.include(SomEnergia::Devise::InvitationsControllerOverride)
  Decidim::Devise::RegistrationsController.include(SomEnergia::Devise::RegistrationsControllerOverride)
  Decidim::Initiatives::InitiativesController.include(SomEnergia::Initiatives::InitiativesControllerOverride)
  Decidim::Meetings::MeetingsController.include(SomEnergia::Meetings::MeetingsControllerOverride)
  Decidim::Proposals::ProposalsController.include(SomEnergia::Proposals::ProposalsControllerOverride)
  Decidim::Proposals::ProposalsController.include(SomEnergia::Proposals::OrderableOverride)
  Decidim::Assemblies::Admin::ParticipatorySpacePrivateUsersCsvImportsController.include(SomEnergia::Admin::HasPrivateUsersCsvImportOverride)
  Decidim::ParticipatoryProcesses::Admin::ParticipatorySpacePrivateUsersCsvImportsController.include(SomEnergia::Admin::HasPrivateUsersCsvImportOverride)

  # consultations
  Decidim::Consultations::Admin::CreateResponse.include(SomEnergia::Consultations::Admin::CreateResponseOverride)
  Decidim::Consultations::Admin::UpdateQuestionConfiguration.include(SomEnergia::Consultations::Admin::UpdateQuestionConfigurationOverride)
  Decidim::Consultations::Admin::UpdateResponse.include(SomEnergia::Consultations::Admin::UpdateResponseOverride)
  Decidim::Consultations::Admin::QuestionConfigurationForm.include(SomEnergia::Consultations::Admin::QuestionConfigurationFormOverride)
  Decidim::Consultations::Admin::ResponseForm.include(SomEnergia::Consultations::Admin::ResponseFormOverride)

  # Assemblies alternative types
  Decidim::Assembly.include(SomEnergia::AssemblyOverride)
  # Participatory Processes alternative menu
  Decidim::ParticipatoryProcess.include(SomEnergia::ParticipatoryProcessOverride)
  Decidim::ParticipatoryProcesses::ProcessFiltersCell.include(SomEnergia::ProcessFiltersCellOverride)

  # Creates a new menu next to Assemblies for every type configured
  AssembliesScoper.alternative_assembly_types.each do |item|
    Decidim.menu :menu do |menu|
      menu.add_item item[:key],
                    I18n.t(item[:key], scope: "decidim.assemblies.alternative_assembly_types"),
                    Rails.application.routes.url_helpers.send("#{item[:key]}_path"),
                    position: item[:position_in_menu],
                    if: Decidim::Assembly.unscoped.where(organization: current_organization, assembly_type: item[:assembly_type_ids]).published.any?,
                    active: :inclusive
    end
  end

  # Creates a new menu next to Processes for every type configured
  ParticipatoryProcessesScoper.scoped_participatory_process_slug_prefixes.each do |item|
    Decidim.menu :menu do |menu|
      menu.add_item item[:key],
                    I18n.t(item[:key], scope: "decidim.participatory_processes.scoped_participatory_process_slug_prefixes"),
                    Rails.application.routes.url_helpers.send("#{item[:key]}_path"),
                    position: item[:position_in_menu],
                    if: (
                      Decidim::ParticipatoryProcess
                      .unscoped
                      .where(organization: current_organization)
                      .where("slug LIKE ANY (ARRAY[?])", item[:slug_prefixes].map { |slug_prefix| "#{slug_prefix}%" })
                      .published
                      .any?
                    ),
                    active: :inclusive
    end
  end
end
