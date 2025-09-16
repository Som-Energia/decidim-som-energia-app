# frozen_string_literal: true

module SomEnergia
  module VerificationsApplicationHelperOverride
    extend ActiveSupport::Concern

    included do
      alias_method :original_authorization_display_data, :authorization_display_data

      def authorization_display_data(authorization)
        return original_authorization_display_data(authorization) unless authorization.name == "cas_member"

        { title: t("#{authorization.name}.name_#{authorization.metadata["member_type"]}", scope: "decidim.authorization_handlers") }
      end
    end
  end
end
