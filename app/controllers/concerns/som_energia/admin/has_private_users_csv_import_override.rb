# frozen_string_literal: true

module SomEnergia
  module Admin
    module HasPrivateUsersCsvImportOverride
      extend ActiveSupport::Concern

      included do
        def create
          enforce_permission_to :csv_import, :space_private_user
          @form = form(Decidim::Admin::ParticipatorySpacePrivateUserCsvImportForm).from_params(params, privatable_to:)

          Decidim::Admin::ProcessParticipatorySpacePrivateUserImportCsv.call(@form, current_user, current_participatory_space) do
            on(:ok) do |errors|
              flash[:notice] = I18n.t("participatory_space_private_users_csv_imports.create.success", scope: "decidim.admin")
              flash[:alert] = "#{errors.size} emails no s'han pogut processar: #{errors.take(50)}" if errors&.size
              redirect_to after_import_path
            end

            on(:invalid) do |msg|
              flash[:alert] = I18n.t("participatory_space_private_users_csv_imports.create.invalid", scope: "decidim.admin")
              flash[:alert] += ": #{msg}" if msg
              render template: "decidim/admin/participatory_space_private_users_csv_imports/new"
            end
          end
        end
      end
    end
  end
end
