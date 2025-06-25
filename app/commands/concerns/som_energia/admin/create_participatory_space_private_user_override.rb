# frozen_string_literal: true

module SomEnergia
  module Admin
    module CreateParticipatorySpacePrivateUserOverride
      extend ActiveSupport::Concern

      included do
        private

        def create_private_user
          action = @via_csv ? "create_via_csv" : "create"
          Decidim.traceability.perform_action!(
            action,
            Decidim::ParticipatorySpacePrivateUser,
            resource: {
              title: user.name,
              cas_user: form.cas_user
            }
          ) do
            Decidim::ParticipatorySpacePrivateUser.find_or_create_by!(
              user:,
              privatable_to: @private_user_to,
              cas_user: form.cas_user
            )
          end
        end
      end
    end
  end
end
